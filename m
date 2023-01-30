Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472BAC54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 08:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjA3IjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 03:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjA3IjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 03:39:24 -0500
X-Greylist: delayed 505 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 00:39:22 PST
Received: from apollo.dupie.be (apollo.dupie.be [IPv6:2001:bc8:3f2a:101::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5CEDBC5
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 00:39:22 -0800 (PST)
Received: from [IPV6:2a02:a03f:eaf7:ff01:cc6b:6666:e19c:b63f] (unknown [IPv6:2a02:a03f:eaf7:ff01:cc6b:6666:e19c:b63f])
        by apollo.dupie.be (Postfix) with ESMTPSA id 2D1161520F27
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 09:39:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dupond.be; s=dkim;
        t=1675067961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JD+VndO8G9aKB9yzEBS4HbYsziamOmk3TdJ2l5Q0EY=;
        b=CLsAWibyVdgjU9qfBwE7Vond+Kilv/X2qhMisXqN3wITK+98P8TumHtG9kOxBItKUb5u4B
        lGu3V8SQyoZ/jdr20OQLCHsk43peee0JTTnNRLMs1/9t7dwrSWl5wdf5R0jPuWiJfoBsRh
        xWPOF1KIjMbW9FFAifDHQQ/x97JLifD2nedlbRpOyaLt+myoBk5EPhXSMici+HycD0PWHH
        f0AFaewK8yzb8Xgs3JupN8aKRoYTwNz2pZI3bQWsHgMAzz6cwaFoX6yyrI7/4beTx1vi5S
        YjIu8Q3dMhp0hWCEVmvVln9m28LtE5L+1TWhVy9y/c1JmdEM+50EvGXQBTl/cQ==
Message-ID: <5520c62d-0496-1f76-0079-23bac54aed70@dupond.be>
Date:   Mon, 30 Jan 2023 09:39:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
From:   Jean-Louis Dupond <jean-louis@dupond.be>
Subject: Re: "Power-on or device reset occurred" after a LUN resize
To:     linux-scsi@vger.kernel.org
References: <a87b6e6e-d35e-2336-4593-c28872760c75@dupond.be>
Content-Language: nl-BE
In-Reply-To: <a87b6e6e-d35e-2336-4593-c28872760c75@dupond.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi All,

Last week we've had the same issue again, but luckily we did some more 
debugging actions when it occurred.
And it looks like a NetApp issue but also partly a kernel issue.

Let me describe:

> Jan 23 13:36:57 srv001 kernel: sd 15:0:0:0: Capacity data has changed
> Jan 23 13:37:57 srv001 kernel: sd 15:0:0:0: Power-on or device reset 
> occurred
We do a LUN resize, and exactly 1 minute later -> A 'Power-on or device 
reset' event.
Now what it looks like, is that the SAN here did not send some 
confirmation for a read/write, and the kernel tried to abort it, but failed.
So it ended up sending a Logical Unit Reset to recover.
-> So this seems to be clearly a SAN bug, as it should always confirm 
read/write.

But then:
When the LUR was send by a host (20 hosts are connected to the same LUN 
here), the following seems to happen:
- Client (linux host) sends a write x
- Client (linux host) sends a write y
- SAN respons with a check condition 0x29 (Power-on or device reset) on 
write y
- Client (linux host) sends a NOP Out after 30 seconds
- NetApp responds with a NOP In
- Client sends an abort for write x after 1 minute (as it was still not 
confirmed from the netapp side)
- NetApp responds with '0x01' (Task not in set)
- Client sends a LUR to the NetApp to reset again, as it still didn't 
know what happend with write x and could not abort it
- The LUR completes, and causes the same issue again on other hosts.

As the NetApp seems to skip write confirmations during a reset, we end 
up in a reset storm because write confirmations get skipped, and a new 
reset is being send again.
And as this happens on all the 20 hosts, this causes an endless reset storm.

Now while I think the NetApp should never skip confirmations of 
read/writes, I think the kernel should remove all non-confirmed 
writes/reads on a LUR event?
This is what SAM-2 
(https://www.cs.cmu.edu/afs/club/usr/jhutz/project/Archives/scsi/sam2r24.pdf) 
specification tells about it:
> To process a logical unit reset the logical unit shall:
> a)Abort all tasks as described in 5.7;

If the kernel on all hosts would remove the unconfirmed writes/reads on 
all hosts after a 0x29, it would never send an abort (which fails), and 
then no more LUR's would be send by the kernel.
And everything would recover correctly after the first LUR.

It would be great if we could improve this :)
There is an issue open on NetApp side also for this!

Thanks
Jean-Louis

On 23/09/2020 11:17, Jean-Louis Dupond wrote:
> Hi,
>
> Last week some action that we do regularly caused some issues.
>
> 00:50:31 CEST -> We resized a iSCSI LUN on a SAN from 3TB -> 4TB.
>
> The clients did detect the change fine, and resized it devices:
>
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: Capacity data has changed
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: Inquiry data has changed
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: supports 
>> implicit TPGS
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: device 
>> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e9 rel port 8
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: Capacity data has changed
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: [sdf] 8589934592 
>> 512-byte logical blocks: (4.40 TB/4.00 TiB)
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: [sdf] 4096-byte 
>> physical blocks
>> Sep 22 00:51:07 server001 kernel: sdf: detected capacity change from 
>> 3298534883328 to 4398046511104
>> Sep 22 00:51:07 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
>> state A non-preferred supports TolUsNA
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: Inquiry data has changed
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: supports 
>> implicit TPGS
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: device 
>> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e9 rel port 7
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: [sdi] 8589934592 
>> 512-byte logical blocks: (4.40 TB/4.00 TiB)
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: [sdi] 4096-byte 
>> physical blocks
>> Sep 22 00:51:07 server001 kernel: sdi: detected capacity change from 
>> 3298534883328 to 4398046511104
>> Sep 22 00:51:07 server001 kernel: sd 17:0:0:1: alua: port group 3e9 
>> state A non-preferred supports TolUsNA
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: Capacity data has changed
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: Inquiry data has changed
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: supports 
>> implicit TPGS
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: device 
>> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e8 rel port 6
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: [sdl] 8589934592 
>> 512-byte logical blocks: (4.40 TB/4.00 TiB)
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: [sdl] 4096-byte 
>> physical blocks
>> Sep 22 00:51:12 server001 kernel: sdl: detected capacity change from 
>> 3298534883328 to 4398046511104
>> Sep 22 00:51:12 server001 kernel: sd 18:0:0:1: alua: port group 3e8 
>> state N non-preferred supports TolUsNA
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: Capacity data has changed
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: Inquiry data has changed
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: supports 
>> implicit TPGS
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: device 
>> t10.NETAPP   LUN 80Vcx]PVRq4F        port group 3e8 rel port 5
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: [sdc] 8589934592 
>> 512-byte logical blocks: (4.40 TB/4.00 TiB)
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: [sdc] 4096-byte 
>> physical blocks
>> Sep 22 00:51:18 server001 kernel: sdc: detected capacity change from 
>> 3298534883328 to 4398046511104
>> Sep 22 00:51:18 server001 kernel: sd 15:0:0:1: alua: port group 3e8 
>> state N non-preferred supports TolUsNA
>> Sep 22 00:52:09 server001 kernel: sd 16:0:0:1: Power-on or device 
>> reset occurred
>> Sep 22 00:52:09 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
>> state A non-preferred supports TolUsNA
>> Sep 22 00:52:09 server001 kernel: sd 17:0:0:1: Power-on or device 
>> reset occurred
>
> But then it kept doing resets:
>> Sep 22 00:54:39 server001 kernel: sd 16:0:0:1: Power-on or device 
>> reset occurred
>> Sep 22 00:54:39 server001 kernel: sd 16:0:0:1: alua: port group 3e9 
>> state A non-preferred supports TolUsNA
>> Sep 22 00:54:39 server001 kernel: sd 17:0:0:1: Power-on or device 
>> reset occurred
>> Sep 22 00:54:39 server001 kernel: sd 17:0:0:1: alua: port group 3e9 
>> state A non-preferred supports TolUsNA
>> Sep 22 00:54:42 server001 kernel: sd 15:0:0:1: Power-on or device 
>> reset occurred
>> Sep 22 00:54:42 server001 kernel: sd 15:0:0:1: alua: port group 3e8 
>> state N non-preferred supports TolUsNA
>
> This caused some multipath failovers until it stopped after ~10 minutes.
>
> We do use ALUA multipath:
> 3600a098038305663785d505652713446 dm-15 NETAPP,LUN C-Mode
> size=4.0T features='3 queue_if_no_path pg_init_retries 50' 
> hwhandler='1 alua' wp=rw
> |-+- policy='service-time 0' prio=50 status=active
> | |- 16:0:0:1 sdf 8:80  active ready running
> | `- 17:0:0:1 sdi 8:128 active ready running
> `-+- policy='service-time 0' prio=10 status=enabled
>   |- 15:0:0:1 sdc 8:32  active ready running
>   `- 18:0:0:1 sdl 8:176 active ready running
>
>
> Who is sending the Power-on or device reset?
> Is that the SAN?
> Or does the client trigger a reset (for which reason then?)?
> The LUN is attachted to multiple servers (all CentOS 8), and all 
> showed the same resets.
>
> It would be nice to find out what caused this!
>
> Thanks for having a look :)
> Jean-Louis
>
>
