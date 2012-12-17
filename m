From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [PATCH 05/10] fnic: fnic driver may hit BUG_ON on device reset
Date: Mon, 17 Dec 2012 23:36:31 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B1288D8A23@xmb-rcd-x08.cisco.com>
References: <1355743494.2352.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:8904 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2LQXgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2012 18:36:33 -0500
In-Reply-To: <1355743494.2352.11.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Content-ID: <27520EE1C057C14893AB1EA643BD8064@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>

Just submitted 05, 06, 07 and 08 fnic patches after verifying compilati=
on
of each patch independently.

Thanks,
Hiral

On 12/17/12 3:24 AM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Mon, 2012-12-10 at 01:21 -0800, Hiral Patel wrote:
>> The issue was observed when LUN Reset is issued through IOCTL or
>>sg_reset
>> utility.
>>=20
>> fnic driver issues LUN RESET to firmware. On successful completion o=
f
>>device
>> reset, driver cleans up all the pending IOs that were issued prior t=
o
>>device
>> reset. These pending IOs are expected to be in ABTS_PENDING state. T=
his
>>works
>> fine, when the device reset operation resulted from midlayer, but no=
t
>>when
>> device reset was triggered from IOCTL path as the pending IOs were n=
ot
>>in
>> ABTS_PENDING state. execution path hits panic if the pending IO is n=
ot
>>in
>> ABTS_PENDING state.
>>=20
>> Changes:
>> The fix replaces BUG_ON check in fnic_clean_pending_aborts() with
>>marking
>> pending IOs as ABTS_PENDING if they were not in ABTS_PENDING state a=
nd
>>skips
>> if they were already in ABTS_PENDING state. An extra check is added =
to
>>validate
>> the abort status of the commands after a delay of 2 * E_D_TOV using =
a
>> helper function. The helper function returns 1 if it finds any pendi=
ng
>>IO in
>> ABTS_PENDING state, belong to the LUN on which device reset was issu=
ed
>>else 0.
>> With this, device reset operation returns success only if the helper
>>funciton
>> returns 0, otherwise it returns failure.
>>=20
>> Other changes:
>> - Removed code in fnic_clean_pending_aborts() that returns failure i=
f
>>it finds
>>   io_req NULL, instead of returning failure added code to continue w=
ith
>>next io
>> - Added device reset flags for debugging in fnic_terminate_rport_io,
>>   fnic_rport_exch_reset, and fnic_clean_pending_aborts
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Hiral Patel <hiralpat@cisco.com>
>
>This one doesn't compile:
>
>drivers/scsi/fnic/fnic_scsi.c: In function =8Cfnic_clean_pending_abort=
s=B9:
>drivers/scsi/fnic/fnic_scsi.c:1654:23: error: =8CFNIC_DEV_RST_ISSUED=B9
>undeclared (first use in this function)
>drivers/scsi/fnic/fnic_scsi.c:1654:23: note: each undeclared identifie=
r
>is reported only once for each function it appears in
>make[3]: *** [drivers/scsi/fnic/fnic_scsi.o] Error 1
>
>And that's because FNIC_DEV_RST_ISSUED isn't #defined until PATCH 06/1=
0
>
>Please redo 05-10 this time making sure they compile in sequence in
>order to maintain bisectability
>
>Thanks,
>
>James
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
