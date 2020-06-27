Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A24C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 817FD2073E
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D/0izTdk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgF0ARl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 20:17:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgF0ARk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 20:17:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R08TX6030116;
        Sat, 27 Jun 2020 00:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9FkJGY1pJdPVHEpZr5VF6XjXadh46q3nG+5nNRI4fH0=;
 b=D/0izTdkQdZYybYBykYPzfrRYxDds/z9Y2NHT4Y4HWBpyxV53wsq+u8xOSdh6nk8gT33
 jJI6MwSAEzFJ7bYj9bF0XXu5Rg15kK9lw2B3vlvDT9KULuGgQg1aSDP7P6G5QSsxtAoZ
 nKoRqAFTX7vE+gxufiX3X4XMDAi+y6jqRBEDwfCreVe8AgYmPA5luBiVNxs0wUzhAGzZ
 fleDjVIGKZ3LjAj0/uFzXHyCYYGcq0Xn4Uwsjbsj2J0gLVFJuxXuLSIpT0GkpXFScFea
 szUIpLp0B8hiTW5XpkRAjP1okhvohU/uIwuAdaoncMdsf5vMN+FDfoGLgnSi2k9U77n4 fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wg3bk5bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 00:17:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R04LG3086441;
        Sat, 27 Jun 2020 00:17:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uurbbju6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 00:17:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R0HbMk010794;
        Sat, 27 Jun 2020 00:17:37 GMT
Received: from localhost.localdomain (/10.159.129.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 00:17:37 +0000
Subject: Re: [PATCH] scsi: Avoid unnecessary iterations on __scsi_scan_target
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <38cee464-7320-87a9-f55c-f0db4679fc0a@oracle.com>
 <1593216207.10175.2.camel@linux.vnet.ibm.com>
From:   Anjali Kulkarni <Anjali.K.Kulkarni@oracle.com>
Message-ID: <7917b23d-0222-d0c7-42a4-b3f18ac24ec2@oracle.com>
Date:   Fri, 26 Jun 2020 17:17:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1593216207.10175.2.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006260171
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks James.

This is on a VM on OCI cloud, using virtio scsi.

Here is output of lspci on the VM:

00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE 
[Natoma/Triton II]
00:01.2 USB controller: Intel Corporation 82371SB PIIX3 USB 
[Natoma/Triton II] (rev 01)
00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
00:02.0 VGA compatible controller: Device 1234:1111 (rev 02)
00:03.0 Ethernet controller: Red Hat, Inc. Virtio network device
00:04.0 SCSI storage controller: Red Hat, Inc. Virtio SCSI

With 16 iterations, we could reduce time by 0.13 secs.

Anjali

On 6/26/20 17:03, James Bottomley wrote:
> On Fri, 2020-06-26 at 16:53 -0700, Anjali Kulkarni wrote:
>> There is a loop in scsi_scan_channel(), which calls
>> __scsi_scan_target() 255 times, even when it has found a
>> target/device on a
>> lun in the first iteration; this ends up adding a 2 secs delay to the
>> boot
>> time. The for loop in scsi_scan_channel() adding 2 secs to boot time
>> is as
>> follows:
>>
>> for (id = 0; id < shost->max_id; ++id) {
>>       ...
>>       __scsi_scan_target(&shost->shost_gendev, channel,
>>                                 order_id, lun, rescan);
>> }
>>
>> __scsi_scan_target() calls scsi_probe_and_add_lun() which calls
>> scsi_probe_lun(), hence scsi_probe_lun() ends up getting called 255
>> times.
>> Each call of scsi_probe_lun() takes 0.007865 secs.
>> 0.007865 multiplied by 255 = 2.00557 secs.
>> By adding a break in above for loop when a valid device on lun is
>> found,
>> we can avoid this 2 secs delay improving boot time by 2 secs.
>>
>> The flow of code is depicted in the following sequence of events:
>>
>> do_scan_async() ->
>>       do_scsi_scan_host()->
>>           scsi_scan_host_selected() ->
>>               scsi_scan_channel()
>>                   __scsi_scan_target() -> this is called shost->max_id
>> times
>>                                           (255 times)
>>                       scsi_probe_and_add_lun-> this is called 255
>> times
>>                           scsi_probe_lun : called 255 times, each call
>>                                            takes 0.007865 secs.
> What HBA is this?  This code is for legacy scanning of busses which
> require it, which is pretty much only SPI.  The max_id of even the
> latest SPI bus should only be 16, so where is 255 coming from?
>
> James
>
