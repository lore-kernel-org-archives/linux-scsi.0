From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH 1/2] libfc: fix mem leak in fc_tm_done()
Date: Thu, 28 Oct 2010 21:43:52 +0800
Message-ID: <AANLkTinwg2OrP1fLLWzJuuuJc8H7RcOppkzYyBP5pAr0@mail.gmail.com>
References: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
	<1288229055.1431.46.camel@fritz>
	<4CC8D7FD.3070608@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab0J1Nny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 09:43:54 -0400
Received: by wwe15 with SMTP id 15so2058867wwe.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 06:43:53 -0700 (PDT)
In-Reply-To: <4CC8D7FD.3070608@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 9:55 AM, Mike Christie <michaelc@cs.wisc.edu> w=
rote:
> On 10/27/2010 08:24 PM, Robert Love wrote:
>>
>> On Mon, 2010-10-25 at 20:37 +0800, Hillf Danton wrote:
>>>
>>> There seems frame should get freed against memory leakage.
>>>
>>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>>> ---
>>>
>>> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-09-13 0=
7:07:38.000000000
>>> +0800
>>> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-10-25 2=
0:31:04.000000000
>>> +0800
>>> @@ -1294,6 +1294,7 @@ static void fc_tm_done(struct fc_seq *se
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!fsp->seq_ptr || !fsp->wait_for_comp=
) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_=
bh(&fsp->scsi_pkt_lock);
>>
>> I wonder if this should be a fc_fcp_unlock_pkt(fsp) since we get the
>> lock with the fc_fcp_lock_pkt(fsp) call above.
>>
According to one question a patch, two were delivered, please check the=
m.

Here I want frame get freed. //Hillf

>
> Did I do that. I think you are right. Not sure what happened if it wa=
s me.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
