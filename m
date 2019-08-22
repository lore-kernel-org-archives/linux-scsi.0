Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D5AC3A59D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 06:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57BC821848
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 06:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FBaQ3gBk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfHVGvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 02:51:32 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10584 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfHVGvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 02:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566456692; x=1597992692;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JkP45uwW+hF8WFoDLnW910LzdkhblqJJv02cLzZ7uJw=;
  b=FBaQ3gBkge/RkTfb/0LxAJMVnrbNLPpZqMiv3vUPjWCK5WGCcyNP6eXx
   oxMRGTe9V4Op+s+OUSKOyXr5Yu32Zq545R7AkiuD0ogGQdpAFhMBqBjBF
   hPKept3fr1mUmrpGX4o6fUcmU+TdTrfRdLfiaFnIgqKLMI4RVOLYvkNQv
   xCrv1PeM1EAohx0XVYy6Gidf65Et9GAHv/RnY3bK30HQFeIwEdRJpmvOb
   E62ILGLWQp/H3FkEUy5UjUgOwAoNP5drInrZ5fBWcoAcys2d82vsJ2EMx
   /RmDCxaXLTKy3n36ruYMVQGpLlH+EVM0CrOsejfxJxm9z6YPoaXMgWNCF
   Q==;
IronPort-SDR: cCAGCEPevxlLFW9Hf3D/ICewU2DZJsiNfcBef5umZR7rYpghFoucLCoQckPhQr8+GJ6GuEHMG8
 Hu3Vl+M972SjQuLUHSnareFYH3Z2y+Ibw72n8XoXYIiE9ehNhV1giB38hBYwKfEbGFq3NQKxRa
 SzYJ3CJgUy83dCLxcnyG/oWDR0fbr3mf8UeaWmFl3lS17PqsASdMfYopiwuvEyrerxlIUNFI4h
 LGV8Kxbipf+L+dCGnTfHtA7AfXRl1igZJcqvVI4fAn1WNBCC4iJ+GJuGmOpwcwt3D6Q0k69Iz/
 p54=
X-IronPort-AV: E=Sophos;i="5.64,415,1559491200"; 
   d="scan'208";a="117992710"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 14:51:31 +0800
IronPort-SDR: ai2gmQTAk/uSuTy4/VGKSBhdo9Q58Q94OVIakwebnlSnrpBKvP7siTPZHRaKqecgGK4WzaW7um
 ksTsLNIlGbJFBxb034l2bRayF45YA3i7DTfXKtjepvo+aX+hWIRgEbcRvFCPfSPSRCtE2XNaWx
 tv4hHEEHJk9kYP3ygC/QE3ncTPdbFY0SvQG3IyPs4AFrJGyvM7/zyNyQM9sirYPnFzXrvF4FFA
 l+8gUAHaI7a/10g34nEiN8IiFzMFIOp6YhK0a9am4eDv7NY6IegJKLwGGxDi+cuvQ1E/GThXDp
 x7MzpKp0H3mnzcvmDwTp3OH3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 23:48:51 -0700
IronPort-SDR: wXCm4mlhEBGVfIA9YLA9WU1v15T8O1df7CfEr9TxbaSxSzh8Bi1UogAm2J8xPpsYFsjROs/zO5
 6TJ55tG4VikMmQgPjbuNOhY9wdwMBifydTWIWqKdK4M1iOCKytdGwiAZybTrzc3CpkXiM+eEAT
 zNDuQVU8f1ZX+zbeLY7/rH0XOjT4trk6e6jACEZZrqAnJ7h/zu6LA5yzAf2pa9HkveZYwQ82G0
 IZMsJUupK1Z98h5/yQBC7UysA4BlQIYJDGwrOmyBCtXAXNiRhz3abMY/1Jp8N7JsGngkNwEMY7
 XmY=
WDCIronportException: Internal
Received: from naota.dhcp.fujisawa.hgst.com ([10.149.53.115])
  by uls-op-cesaip02.wdc.com with SMTP; 21 Aug 2019 23:51:30 -0700
Received: (nullmailer pid 3941984 invoked by uid 1000);
        Thu, 22 Aug 2019 06:51:29 -0000
Date:   Thu, 22 Aug 2019 15:51:29 +0900
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted
 scsi device
Message-ID: <20190822065129.owelr7fkbfap42r2@naota.dhcp.fujisawa.hgst.com>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
 <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org>
 <5D5C1159.4030507@redhat.com>
 <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
 <5D5C2B9D.1070307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5D5C2B9D.1070307@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2019 at 12:19:25PM -0500, Mike Christie wrote:
>CAUTION: This email originated from outside of Western Digital. Do not click on links or open attachments unless you recognize the sender and know that the content is safe.
>
>
>On 08/20/2019 10:43 AM, Bart Van Assche wrote:
>> On 8/20/19 8:27 AM, Mike Christie wrote:
>>> tcm loop does not take a reference to the scsi_device at creation/link
>>> time then need to release at removal/unlink time. The above
>>> scsi_device_put is for the successful scsi_device_lookup call. tcm loop
>>> works like a scsi host driver that does its own scanning via
>>> scsi_add_device (maybe similar to scsi drivers that are raid cards).
>>> Like other host drivers it does not take a reference to the device when
>>> it is added and relies on scsi-ml to handle all that for it before doing
>>> operations like queuecommand.
>>>
>>> The leak is if you removed the scsi_device via the scsi ml sysfs
>>> interface then there is no way to completely unlink the lio port because
>>> if scsi_device_lookup fails we return from the function and do not do
>>> not release our refcount on the tl_tpg_port_count.
>>
>> Hi Mike,
>>
>> Does this mean that you think that this patch is the right way to
>> address the reported issue?
>>
>
>It fixes that very specific issue, but it leaves others. Maybe it could
>be used in a patchset that builds on it?
>
>I think we could hit issues like:
>
>1. tcm_loop_port_unlink runs and releases tl_tpg_port_count count.
>2. userspace initiated scan commands were in progress and complete.
>target_fabric_port_unlink->core_dev_del_lun->core_tpg_remove_lun was
>waiting for those last IOs and now completes and deletes the mapped lun
>from lio.
>3. scsi-ml scan completed before the unmapping and so now we have a
>scsi_device but no lio lun mapping.

Right, this can happen. Actually, this can happen even without my
patch if the scan can occur between scsi_remove_device() in
tcm_loop_port_unlink() and core_tpg_remove_lun(), right?

I presumed we need to use some lock around here. I digged around the
code but cannot figure out a suitable lock here. Actually, I tried
(struct Scsi_Host)->scan_mutex, but it didn't work.

Or, we should block tcm_loop_queuecommand() to proceed the INQUIRY
commads on this LUN? move/introduce new hook after
transport_clear_lun_ref(lun)?

Any idea?

>The problem with this is that:
>
>1. We can hit mismatched settings like this:
>
>A. We now have this scsi_device at LUN0, but no lio mapping. User thinks
>everything got cleaned up ok, so they decide to map another lio lun.
>B. tcm_loop_port_link just does a scsi_add_device which does
>scsi_probe_and_add_lun with rescan=true. So the original scsi_device is
>returned. It is not reprobed so whatever settings the old device has
>will be used. Maybe that scsi_device was for a disk and now the user was
>adding a CD.
>
>2. And hit races like:
>
>A. tl_tpg_port_count might now be zero so the tpg and nexus can be removed.
>B. That removal can race with IO being sent to the scsi_device. If a
>command has passed tcm_loop_submission_work's NULL tl_nexus check then
>we will hit a NULL pointer crash later in the function.
>
>
