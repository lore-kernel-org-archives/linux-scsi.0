From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Mon, 12 Aug 2013 12:47:53 +0530
Message-ID: <52088C21.4080804@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <1374280885-11526-2-git-send-email-mita@fixstars.com> <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com> <51F608F4.9020107@codeaurora.org> <51F6493C.3020105@codeaurora.org> <002a01ce8d25$1b0e4730$512ad590$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3HLHR6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2013 03:17:58 -0400
In-Reply-To: <002a01ce8d25$1b0e4730$512ad590$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On 7/30/2013 6:32 PM, Seungwon Jeon wrote:
> On Mon, July 29, 2013, Sujit Reddy Thumma wrote:
>> On 7/29/2013 11:47 AM, Subhash Jadavani wrote:
>>> On 7/26/2013 7:15 PM, Seungwon Jeon wrote:
>>>> Fatal error in OCS(overall command status) field indicates
>>>> error conditions which is not covered by UFSHCI.
>>>> It means that host cannot define the result of command status
>>>> and therefore host may need to check transfer response UPIU's
>>>> response and status field.
>>>> It was actually found that 'CHECK CONDITION' is stored in status
>>>> field of UPIU where OCS is 'FATAL ERROR'.
>> It looks like you are assuming that there will be some kind of respo=
nse
>> from the device. But the spec. mentions - "OCS_FATAL ERROR: within h=
ost
>> controller that is not covered by the error conditions described abo=
ve
>> in this table."
> Yes, error interrupt doesn't happen actually.
>
>> So spec. left everything to implementers on how to trigger this erro=
r.
>> Also, it says "within host controller" so ufshcd_is_valid_req_rsp()
>> might fail as well.
>>
>> I couldn't understand why there is a need for a host controller to
>> interpret the SCSI command status and raise an OCS_FATAL_ERROR?
> I feel like OCS values are related to syntax problem except OCS_FATAL=
_ERROR.
> Basically, host controller may need to refer the Response field[Targe=
t Success/Target Failure] of response UPIU.
> It's a overall result from response UPIU.
> When Response field is 'Target Failure', if host controller updates t=
he OCS field with 'SUCCESS', it's not proper behavior.
> In this case host may refer the Status field of response UPIU to deci=
de the OCS result.
> Of course, it's not clear thing and could depends on host's implement=
ation,
> because there is no obvious description for that.
> But if we consider the way to report UTP error from UFSHCI 8.2.4,
> we can check the Response UPIU for more detailed error condition rega=
rdless OCS value.
> Could you check your host side?

This is what our host documentation says: " SW may check the contents o=
f=20
Response UPIU when OCS !=3D0 for debug purposes. It may (or may not) he=
lp=20
to understand the error scenario better. This is needed only for debug.=
=20
When system is stable, OCS should be 0." So this clearly means that we=20
shouldn't rely on the response UPIU if the OCS is non-zero hence simply=
=20
ignore it.

 > "When Response field is 'Target Failure', if host controller updates=
=20
the OCS field with 'SUCCESS', it's not proper behavior."

I doubt whether your above understanding is true from Host controller=20
specification point of view. Host controller would not decode the=20
=E2=80=9CResponse=E2=80=9D field of the =E2=80=9Cresponse UPIU=E2=80=9D=
, it would only decode the=20
=E2=80=9CTransaction Type=E2=80=9D & =E2=80=9CTask Tag=E2=80=9D (and ma=
y be =E2=80=9CLUN=E2=80=9D) from the response=20
UPIU in order to find out the correct slot in the transfer/task request=
=20
list. Even 7.3.2.3 in UFSHCI spec also mentions the same.

I guess with this i don't see a need for this patch unless you feel=20
otherwise.

Regards,
Subhash

>
> Thanks,
> Seungwon Jeon
>
>> If it is clarified by the spec. then we can have generic implementat=
ion
>> otherwise I would prefer to make this specific to those host control=
lers
>> that raise OCS_FATAL_ERROR for CHECK_CONDITION.
>>
>>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>>> ---
>>>>    drivers/scsi/ufs/ufshcd.c |    3 +--
>>>>    1 files changed, 1 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index b743bd6..4cf3a2d 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *h=
ba,
>>>> struct ufshcd_lrb *lrbp)
>>>>        switch (ocs) {
>>>>        case OCS_SUCCESS:
>>>> -
>>>> +    case OCS_FATAL_ERROR:
>>>>            /* check if the returned transfer response is valid */
>>>>            result =3D ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
>>> I don't see the response UPIU data of the last command response is
>>> cleared anywhere in the driver. This means its quite possible that =
if
>>> the current command failed (and if it is using the same tag as the =
last
>>> succeeded command) with the OCS_FATAL_ERROR then response UPIU (poi=
nted
>>> by lrbp->ucd_rsp_ptr) content may be still the same as the last one=
=2E If
>>> we ensure to clear the response UPIU data after every command compl=
etion
>>> then only we can rely on the response  UPIU content in case of fata=
l
>>> errors.
>>>
>>> Regards,
>>> Subhash
>>>>            if (result) {
>>>> @@ -1229,7 +1229,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *h=
ba,
>>>> struct ufshcd_lrb *lrbp)
>>>>        case OCS_MISMATCH_DATA_BUF_SIZE:
>>>>        case OCS_MISMATCH_RESP_UPIU_SIZE:
>>>>        case OCS_PEER_COMM_FAILURE:
>>>> -    case OCS_FATAL_ERROR:
>>>>        default:
>>>>            result |=3D DID_ERROR << 16;
>>>>            dev_err(hba->dev,
>>
>> --
>> Regards,
>> Sujit
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
