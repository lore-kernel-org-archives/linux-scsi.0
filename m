From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH] bfa: avoid buffer overrun for 12-byte model name
Date: Mon, 24 Dec 2012 00:43:32 -0700
Message-ID: <51BD2AE8016AE441B63F5661159C990203500EA02A@BRM-EXCH-3.corp.brocade.com>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-5-git-send-email-jim@meyering.net>
	<B5EE62D80D50B84BB9E5174F7FCCE80A2839ABC2C4@HQ1-EXCH02.corp.brocade.com>
	<87d32ll2nk.fsf@rho.meyering.net> <87wqytbic5.fsf@rho.meyering.net>
 <87ipadbh1w.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:37717 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab2LXHok convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Dec 2012 02:44:40 -0500
In-Reply-To: <87ipadbh1w.fsf@rho.meyering.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Cc: Andi Kleen <andi@firstfloor.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Jim,
Due to BFA_FCS_PORT_SYMBNAME_MODEL_SZ macro value of 12, we are missing some part of the model name in port/node symbolic name and seeing issues related to null termination. Mismatch between the actual model size and number of bytes copied to symbolic name is a bug. Can you please fix this by changing BFA_FCS_PORT_SYMBNAME_MODEL_SZ  to 16 and reduce os_name macro (BFA_FCS_PORT_SYMBNAME_OSINFO_SZ) to 44, so that both the issues i.e symbolic name and null termination will be fixed.

Thanks,
Vijay

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jim Meyering
Sent: Sunday, October 14, 2012 1:51 PM
To: Krishna Gudipati
Cc: Andi Kleen; linux-kernel@vger.kernel.org; James E.J. Bottomley; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] bfa: avoid buffer overrun for 12-byte model name

Jim Meyering wrote:
> Jim Meyering wrote:
>> Krishna Gudipati wrote:
>>>> -----Original Message-----
>>>> From: Jim Meyering [mailto:jim@meyering.net]
>>>> Sent: Monday, August 20, 2012 9:55 AM
>>>> To: linux-kernel@vger.kernel.org
>>>> Cc: Jim Meyering; Jing Huang; Krishna Gudipati; James E.J. 
>>>> Bottomley; linux- scsi@vger.kernel.org
>>>> Subject: [PATCH] bfa: avoid buffer overrun for 12-byte model name
>>>>
>>>> From: Jim Meyering <meyering@redhat.com>
>>>>
>>>> we use strncpy to copy a model name of length up to 15 (16, if you 
>>>> count the NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
>>>> However, strncpy does not always NUL-terminate, so whenever the 
>>>> original model string has strlen >= 12, the following strncat reads 
>>>> beyond end of the -
>>>> >sym_name buffer as it attempts to find end of string.
>>>>
>>>> bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric) {
>>>> 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
>>>> 	...
>>>> 	strncpy((char *)&port_cfg->sym_name, model,
>>>> 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
>>>> 	strncat((char *)&port_cfg->sym_name, 
>>>> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>>>> 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>>>> 	...
>>>>
>>>> bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model) {
>>>> 	struct bfi_ioc_attr_s	*ioc_attr;
>>>>
>>>> 	WARN_ON(!model);
>>>> 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
>>>>
>>>> BFA_ADAPTER_MODEL_NAME_LEN = 16
>>>>
>>>> Signed-off-by: Jim Meyering <meyering@redhat.com>
>>>> ---
>>>>  drivers/scsi/bfa/bfa_fcs.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/bfa/bfa_fcs.c 
>>>> b/drivers/scsi/bfa/bfa_fcs.c index
>>>> eaac57e..3329493 100644
>>>> --- a/drivers/scsi/bfa/bfa_fcs.c
>>>> +++ b/drivers/scsi/bfa/bfa_fcs.c
>>>> @@ -713,6 +713,7 @@ bfa_fcs_fabric_psymb_init(struct 
>>>> bfa_fcs_fabric_s
>>>> *fabric)
>>>>  	/* Model name/number */
>>>>  	strncpy((char *)&port_cfg->sym_name, model,
>>>>  		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
>>>> +	port_cfg->sym_name[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1]
>>>> = 0;
>>>>  	strncat((char *)&port_cfg->sym_name, 
>>>> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>>>>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>>>
>>> Nacked-by: Krishna Gudipati <kgudipat@brocade.com>
>>>
>>> Hi Jim,
>>>
>>> This model number is of length 12 bytes and the logic added here 
>>> will reset the model last byte.
>>> In addition strncat does not need the src to be null terminated, the 
>>> change does not compile even.
>>> NACK to this change.
>>
>> Hi Krishna,
>>
>> Thanks for the quick feedback and sorry the patch wasn't quite right.
>> However, the log is accurate: there is at least a theoretical problem 
>> when the string in "model" (a buffer of size 16 bytes) has strlen >= 12.
>> While strncat does not require that its second argument be 
>> NUL-terminated, the first one (the destination) must be.  Otherwise, 
>> it has no way to determine the end of the string to which it must append the source bytes.
>
> Ping?
> In case it wasn't clear, there *is* a risk of buffer overflow, which 
> happens when strncpy makes it so strncat's destination is not NUL 
> terminated.
>
> If you require support for 12-byte model numbers, then you'll have to 
> increase the length of that buffer
> (BFA_FCS_PORT_SYMBNAME_MODEL_SZ) to at least 13.
>
> I've just rebased, and thus confirmed that the patches still apply.
>
>> Here is a v2 patch to which I've added the requisite (char*) cast.
>> However, this whole function is rather unreadable due to the 
>> repetition (12 times!) of "(char *)&port_cfg->sym_name".
>> In case someone prefers to factor out that repetition, I've appended 
>> a larger, v3 patch to do that.

Taking Andi's advice, I've made the offending code use strlcpy in place of strncpy.  More importantly, I've fixed the same bug also in the following, nearly identical function.

-- >8 --

Two functions have this problem:
  bfa_fcs_fabric_psymb_init
  bfa_fcs_fabric_nsymb_init
They use strncpy to copy a model name of length up to 15 (16, if you count the NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
However, strncpy does not always NUL-terminate, so whenever the original model string has strlen >= 12, the following strncat reads beyond end of the ->sym_name buffer as it attempts to find end of string.
Instead, use strlcpy, which does guarantee NUL-termination.

bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric) {
	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
	...
	strncpy((char *)&port_cfg->sym_name, model,
		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
	...

bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model) {
	struct bfi_ioc_attr_s	*ioc_attr;

	WARN_ON(!model);
	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);

BFA_ADAPTER_MODEL_NAME_LEN = 16

Signed-off-by: Jim Meyering <jim@meyering.net>
---
 drivers/scsi/bfa/bfa_fcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index d428808..c7f476c 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -837,7 +837,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);

 	/* Model name/number */
-	strncpy((char *)&port_cfg->sym_name, model,
+	strlcpy((char *)&port_cfg->sym_name, model,
 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
@@ -898,7 +898,7 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);

 	/* Model name/number */
-	strncpy((char *)&port_cfg->node_sym_name, model,
+	strlcpy((char *)&port_cfg->node_sym_name, model,
 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
 	strncat((char *)&port_cfg->node_sym_name,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
--
1.8.0.rc2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
