From: Dmitry Melekhov <dm@belkam.com>
Subject: Re: low read performance after removing/adding iscsi device
Date: Tue, 18 Oct 2016 13:19:46 +0400
Message-ID: <8a732bb8-22b7-2441-21f8-263754e127dc@belkam.com>
References: <07a18a53-77ef-2aab-df59-70371d4e60bc@belkam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.belkam.com ([78.85.14.180]:52208 "EHLO relay2.belkam.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933560AbcJRJTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 05:19:51 -0400
Received: from inetgw1.p98.belkam.com (localhost [127.0.0.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by relay2.belkam.com (Postfix) with ESMTPS id 051CE2071F
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 13:19:47 +0400 (+04)
Received: from localhost (localhost [127.0.0.1])
        by inetgw1.p98.belkam.com (Postfix) with ESMTP id E85456907A
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 13:19:46 +0400 (+04)
Received: from inetgw1.p98.belkam.com ([127.0.0.1])
        by localhost (inetgw1.p98.belkam.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7gz4+KuwiN5a for <linux-scsi@vger.kernel.org>;
        Tue, 18 Oct 2016 13:19:46 +0400 (+04)
Received: from [192.168.22.229] (dm.p98.belkam.com [192.168.22.229])
        by inetgw1.p98.belkam.com (Postfix) with ESMTP id CA865616D5
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 13:19:46 +0400 (SAMT)
In-Reply-To: <07a18a53-77ef-2aab-df59-70371d4e60bc@belkam.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

OK, looks like I found workaround-
iscsi target have to map at least one lun for host, before it login.
Otherwise I have low read performance and sometimes host doesn't recognize
snapshot's lun without logoff/logon.
Don't know is it HPE MSA or linux bug..


17.10.2016 09:46, Dmitry Melekhov пишет:
> Hello!
>
>
> We have two HPE MSA 2040 storages , so I'd like to do some volumes 
> backups from one storage to another.
> Unfortunately, we have no replication license, so I decided to do this 
> by using snapshots and dd :-)
>
> What I'm doing:
> 1. creating snapshot on MSA;
> 2. maps it to host on MSA;
> 3. iscsiadm -m session --rescan
> 4. /usr/bin/rescan-scsi-bus.sh --forcerescan -f
>
> then use mpath device, then
>
> 5. unmap in MSA;
> 6. remove snapshot;
> 7. /usr/bin/rescan-scsi-bus.sh --forcerescan -f
> 8. sometimes for some reason mpatha is in use, so
> dmsetup -f remove mpatha
> 9. I want every new snapshot be mpatha, so I remove info from multipath:
> systemctl stop multipathd
> rm -f /etc/multipath/*
> systemctl start multipathd
> other luns, on another system has names in multipath.conf.
>
> Everything looks fine, but problem here is that at first run after 
> reboot read performance is twice higher:
>
> after reboot:
> 603 MB/s and 200Gb volume dd time is 10 minutes,
>
> second and any other run:
> 191 MB/s and 20-25 minutes run
>
> These are outputs from
>
> dd bs=8M  if=/dev/mapper/mpatha of=/dev/null status=progress
>
>
> This is not only for mpatha, but for any drive in it:
> mpatha (3600c0ff000267d5338e5005801000000) dm-4 HP ,MSA 2040 SAN
> size=200G features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=50 status=active
> | |- 2:0:0:0 sdq 65:0 active ready running
> | `- 4:0:0:0 sds 65:32 active ready running
> `-+- policy='round-robin 0' prio=10 status=enabled
> |- 3:0:0:0 sdr 65:16 active ready running
> `- 5:0:0:0 sdt 65:48 active ready running
>
> I tested sdq and sds.
>
> Btw, these names are always the same, i.e. after creating new 
> snapshot, rescan, etc, every drive has the same name.
>
> I I create another snapshot, i.e have 2 mapped snapshots in system - 
> result is the same, i.e. if first snapshot was removed,
>
> rescanned, and added again it is slow, but second one is OK, until 
> recreation.
>
> Other luns, from another system, which are never disconnects, has no 
> such problem.
> I tried to do iscsi logoff/logon, but no change....
>
> I even tried to install kernel-ml from el-repo , i.e. 4.8 , but it 
> gives me the same result...
>
> Just because reboot solves this problem I guess something is wrong in 
> scsi subsystem...
>
> Thank you!
>
>
>

