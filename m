Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB312C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 15:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B51BE206FA
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 15:42:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="LzRMW6S+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbgFRPl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:41:59 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.5]:52566 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgFRPly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 11:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592494911; i=@ts.fujitsu.com;
        bh=DE8c1jE9f6+bxh6eSibfJhSy8DLTCaptUdSapBWd2vw=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=LzRMW6S+YZ/Bo3URTTt/1BArc3ot5/yyYlERbS57vWJml9/zHtevZrpqausl/5sti
         KpE/Fnu6Co7t2uH2JMvfHB3u4tTQOI8MEURa2socS5r77RIhRYWDkhr8ghLsQNDKtQ
         IUPoAgweckqBsNSV6lpFeWUeDIRRrOlr7xnbZ7MmvezvFsDLQunZmtj3onLDv2W7UA
         649/xAkyg/eYBJ7L1DcgG8S3FnryDMRcv20A0Bkxr2sQ2jAyjZ/fHhzke3DutwE3Fz
         cnkQC/UF4nmSmYksu8JiXGMPb0tk0Uy77k3PXRdTIFJ6+j/0PsEWfVE+iW7nxp0DKz
         ChrplHrs2vrlQ==
Received: from [100.113.3.53] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-central-1.aws.symcld.net id 7F/54-29316-F3B8BEE5; Thu, 18 Jun 2020 15:41:51 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRWlGSWpSXmKPExsViZ8MxVde++3W
  cwa5uPovDC98wWXRf38FmMaMtzGL58X9MFn8n3WC1aF36lsmBzWPnrLvsHo97zrB5fHx6i8Xj
  8ya5AJYo1sy8pPyKBNaMk4cvsxWc1Kl4s+UNcwPjRPUuRi4OIYHJjBJ793SxQjj9jBI7O/azd
  DFycggLxEh03p/MCJIQEVjDKLHo9VImkASzgKvE4oPzmCA6ljJKTH01lRkkwSZgILFi0n2wbl
  4BR4mn+w+B2SwCqhKLDoM0cHCICoRLzN3hAlEiKHFy5hOwEk4BO4lz91dBzTeTmLf5ITOELS5
  x68l8qLi2xLKFr5knMPLPQtI+C0nLLCQts5C0LGBkWcVokVSUmZ5RkpuYmaNraGCga2horGuo
  a2qol1ilm6iXWqqbnJpXUpQIlNRLLC/WK67MTc5J0ctLLdnECIyHlEJG4x2MB19/0DvEKMnBp
  CTKO6XpdZwQX1J+SmVGYnFGfFFpTmrxIUYZDg4lCd7b7UA5waLU9NSKtMwcYGzCpCU4eJREeB
  +DpHmLCxJzizPTIVKnGHU53v1cvIhZiCUvPy9VSpw3HqRIAKQoozQPbgQsTVxilJUS5mVkYGA
  Q4ilILcrNLEGVf8UozsGoJMy7HGQKT2ZeCdymV0BHMAEdoRX+CuSIkkSElFQD0+xvGx7965S5
  ffb268WBayrYXI7wSLP6s70wiJ9UPU26USPwlN7ep3vnbprQln5jyamOnjesWt1J127Vfdn5q
  pHv6MP+/ytCzb5c8p75kjUveJaPvwnvX8YtojJLpS1O/H9QvdPj2BMm5ZqDUlmiOYodzy/8Ln
  xwhOe5ibpO3af1x3QbPYMc0yuDpix35zkhGh6zwztB656uWhTD+qsZN647NH2xTdnj1/m8Ukq
  tO4VteWDclg/LM9Te2uy9M1tP7uNtBi/hR5t09pZKR140nys64ZV8DefZZ1zNm54zyD3WWNjL
  rXvuzbKpqX8eOysJlTIee39kfakgp5B280O735unK9y6++9R0luLbYGHFyixFGckGmoxFxUnA
  gAHbjAzjgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-30.tower-232.messagelabs.com!1592494910!423257!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29804 invoked from network); 18 Jun 2020 15:41:51 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-30.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 15:41:51 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05IFfiLc020253;
        Thu, 18 Jun 2020 16:41:44 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 5AA4920300;
        Thu, 18 Jun 2020 17:41:41 +0200 (CEST)
Subject: Re: [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in
 tcmu_flush_dcache_range on ARM
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
 <20200618131632.32748-3-bstroesser@ts.fujitsu.com>
 <5e4be724-bd54-3a4d-e0d4-8c60910b0c0a@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <b5b0bead-a94e-3a0f-f862-2c946717cd6b@ts.fujitsu.com>
Date:   Thu, 18 Jun 2020 17:41:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5e4be724-bd54-3a4d-e0d4-8c60910b0c0a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-18 17:00, Mike Christie wrote:
> On 6/18/20 8:16 AM, Bodo Stroesser wrote:
>> This patch fixes the following crash
>> (see=20
>> https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?i=
d=3D208045__;!!GqivPVa7Brio!O7JgZIL3VPAzIqwJfZjL48y8M90K3HXv3pUVeoCzZ-vXo=
vCpx5g7xMg-z5aAiVXVtkfE$=20
>> )
>>
>> =C2=A0 Process iscsi_trx (pid: 7496, stack limit =3D 0x0000000010dd111=
a)
>> =C2=A0 CPU: 0 PID: 7496 Comm: iscsi_trx Not tainted 4.19.118-0419118-g=
eneric
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #202004230533
>> =C2=A0 Hardware name: Greatwall QingTian DF720/F601, BIOS 601FBE20 Sep=
 26 2019
>> =C2=A0 pstate: 80400005 (Nzcv daif +PAN -UAO)
>> =C2=A0 pc : flush_dcache_page+0x18/0x40
>> =C2=A0 lr : is_ring_space_avail+0x68/0x2f8 [target_core_user]
>> =C2=A0 sp : ffff000015123a80
>> =C2=A0 x29: ffff000015123a80 x28: 0000000000000000
>> =C2=A0 x27: 0000000000001000 x26: ffff000023ea5000
>> =C2=A0 x25: ffffcfa25bbe08b8 x24: 0000000000000078
>> =C2=A0 x23: ffff7e0000000000 x22: ffff000023ea5001
>> =C2=A0 x21: ffffcfa24b79c000 x20: 0000000000000fff
>> =C2=A0 x19: ffff7e00008fa940 x18: 0000000000000000
>> =C2=A0 x17: 0000000000000000 x16: ffff2d047e709138
>> =C2=A0 x15: 0000000000000000 x14: 0000000000000000
>> =C2=A0 x13: 0000000000000000 x12: ffff2d047fbd0a40
>> =C2=A0 x11: 0000000000000000 x10: 0000000000000030
>> =C2=A0 x9 : 0000000000000000 x8 : ffffc9a254820a00
>> =C2=A0 x7 : 00000000000013b0 x6 : 000000000000003f
>> =C2=A0 x5 : 0000000000000040 x4 : ffffcfa25bbe08e8
>> =C2=A0 x3 : 0000000000001000 x2 : 0000000000000078
>> =C2=A0 x1 : ffffcfa25bbe08b8 x0 : ffff2d040bc88a18
>> =C2=A0 Call trace:
>> =C2=A0=C2=A0 flush_dcache_page+0x18/0x40
>> =C2=A0=C2=A0 is_ring_space_avail+0x68/0x2f8 [target_core_user]
>> =C2=A0=C2=A0 queue_cmd_ring+0x1f8/0x680 [target_core_user]
>> =C2=A0=C2=A0 tcmu_queue_cmd+0xe4/0x158 [target_core_user]
>> =C2=A0=C2=A0 __target_execute_cmd+0x30/0xf0 [target_core_mod]
>> =C2=A0=C2=A0 target_execute_cmd+0x294/0x390 [target_core_mod]
>> =C2=A0=C2=A0 transport_generic_new_cmd+0x1e8/0x358 [target_core_mod]
>> =C2=A0=C2=A0 transport_handle_cdb_direct+0x50/0xb0 [target_core_mod]
>> =C2=A0=C2=A0 iscsit_execute_cmd+0x2b4/0x350 [iscsi_target_mod]
>> =C2=A0=C2=A0 iscsit_sequence_cmd+0xd8/0x1d8 [iscsi_target_mod]
>> =C2=A0=C2=A0 iscsit_process_scsi_cmd+0xac/0xf8 [iscsi_target_mod]
>> =C2=A0=C2=A0 iscsit_get_rx_pdu+0x404/0xd00 [iscsi_target_mod]
>> =C2=A0=C2=A0 iscsi_target_rx_thread+0xb8/0x130 [iscsi_target_mod]
>> =C2=A0=C2=A0 kthread+0x130/0x138
>> =C2=A0=C2=A0 ret_from_fork+0x10/0x18
>> =C2=A0 Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260)
>> =C2=A0 ---[ end trace 1e451c73f4266776 ]---
>>
>> The solution is based on patch:
>>
>> =C2=A0=C2=A0 "scsi: target: tcmu: Optimize use of flush_dcache_page"
>>
>> which restricts the use of tcmu_flush_dcache_range() to
>> addresses from vmalloc'ed areas only.
>>
>> This patch now replaces the virt_to_page() call in
>> tcmu_flush_dcache_range() - which is wrong for vmalloced addrs -
>> by vmalloc_to_page().
>>
>> The patch was tested on ARM with kernel 4.19.118 and 5.7.2
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> Tested-by: JiangYu <lnsyyj@hotmail.com>
>> Tested-by: Daniel Meyerholt <dxm523@gmail.com>
>> ---
>> =C2=A0 drivers/target/target_core_user.c | 2 +-
>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_user.c=20
>> b/drivers/target/target_core_user.c
>> index a65e9671ae7a..835d3001cb0e 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -601,7 +601,7 @@ static inline void tcmu_flush_dcache_range(void=20
>> *vaddr, size_t size)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size =3D round_up(size+offset, PAGE_SIZ=
E);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (size) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flush_dcache_page(virt_to_=
page(start));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flush_dcache_page(vmalloc_=
to_page(start));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start +=3D PAGE=
_SIZE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size -=3D PAGE_=
SIZE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> For this bug we only need to change the flush in is_ring_space_avail=20
> right? It's what is accessing the mb which is vmalloc'd.
No, is_ring_space_avail was just the first caller of
tcmu_flush_dcache_range for vmalloc'ed pages, so it crashed there.

The entiere address range exposed to userspace via uio consists of
two parts:
1) mb + command ring are vmalloc'ed in a single vzalloc call
    during initialization of a tcmu device.
2) the data area which is allocated page by page calling
    alloc_page()

The second part is handled by (scatter|gather)_data_area. For the
calls from these routines I think usage of virt_to_page in
tcmu_flush_dcache_range was fine. But patch number 1 of this
series replaced these called with direct calls to flush_dcache_page.

So all remaining calls to tcmu_flush_dcache_range after patch 1
are calls for vmalloc'ed addresses. Therefore after patch 1 we can
safely replace virt_to_page with vmalloc_to_page.

So it turned out that patch 1, which in the beginning was thought
to be an optimization, now also simplifies the crash fix.

>=20
> Is it reccommended to call vmalloc_to_page on a page we get with=20
> alloc_page and is the mm then always going to do the right thing for us=
=20
> (I do not know the mm code well and just quickly scanned the=20
> Documentation and comments, but could not find anything), or could we=20
> hit similar issues where we are using the wrong call on different types=
=20
> of allocated memory down the line?
