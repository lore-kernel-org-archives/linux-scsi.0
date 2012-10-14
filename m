From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH] bfa: avoid buffer overrun for 12-byte model name
Date: Sun, 14 Oct 2012 09:53:14 +0200
Message-ID: <87wqytbic5.fsf@rho.meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-5-git-send-email-jim@meyering.net>
	<B5EE62D80D50B84BB9E5174F7FCCE80A2839ABC2C4@HQ1-EXCH02.corp.brocade.com>
	<87d32ll2nk.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d32ll2nk.fsf@rho.meyering.net> (Jim Meyering's message of
	"Mon, 20 Aug 2012 22:38:39 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Krishna Gudipati <kgudipat@Brocade.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jim Meyering wrote:
> Krishna Gudipati wrote:
>>> -----Original Message-----
>>> From: Jim Meyering [mailto:jim@meyering.net]
>>> Sent: Monday, August 20, 2012 9:55 AM
>>> To: linux-kernel@vger.kernel.org
>>> Cc: Jim Meyering; Jing Huang; Krishna Gudipati; James E.J. Bottomley; linux-
>>> scsi@vger.kernel.org
>>> Subject: [PATCH] bfa: avoid buffer overrun for 12-byte model name
>>>
>>> From: Jim Meyering <meyering@redhat.com>
>>>
>>> we use strncpy to copy a model name of length up to 15 (16, if you count the
>>> NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
>>> However, strncpy does not always NUL-terminate, so whenever the original
>>> model string has strlen >= 12, the following strncat reads beyond end of the -
>>> >sym_name buffer as it attempts to find end of string.
>>>
>>> bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric) {
>>> 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
>>> 	...
>>> 	strncpy((char *)&port_cfg->sym_name, model,
>>> 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
>>> 	strncat((char *)&port_cfg->sym_name,
>>> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>>> 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>>> 	...
>>>
>>> bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model) {
>>> 	struct bfi_ioc_attr_s	*ioc_attr;
>>>
>>> 	WARN_ON(!model);
>>> 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
>>>
>>> BFA_ADAPTER_MODEL_NAME_LEN = 16
>>>
>>> Signed-off-by: Jim Meyering <meyering@redhat.com>
>>> ---
>>>  drivers/scsi/bfa/bfa_fcs.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index
>>> eaac57e..3329493 100644
>>> --- a/drivers/scsi/bfa/bfa_fcs.c
>>> +++ b/drivers/scsi/bfa/bfa_fcs.c
>>> @@ -713,6 +713,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s
>>> *fabric)
>>>  	/* Model name/number */
>>>  	strncpy((char *)&port_cfg->sym_name, model,
>>>  		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
>>> +	port_cfg->sym_name[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1]
>>> = 0;
>>>  	strncat((char *)&port_cfg->sym_name,
>>> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>>>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>>
>> Nacked-by: Krishna Gudipati <kgudipat@brocade.com>
>>
>> Hi Jim,
>>
>> This model number is of length 12 bytes and the logic added here will
>> reset the model last byte.
>> In addition strncat does not need the src to be null terminated, the
>> change does not compile even.
>> NACK to this change.
>
> Hi Krishna,
>
> Thanks for the quick feedback and sorry the patch wasn't quite right.
> However, the log is accurate: there is at least a theoretical problem
> when the string in "model" (a buffer of size 16 bytes) has strlen >= 12.
> While strncat does not require that its second argument be NUL-terminated,
> the first one (the destination) must be.  Otherwise, it has no way to
> determine the end of the string to which it must append the source bytes.

Ping?
In case it wasn't clear, there *is* a risk of buffer overflow,
which happens when strncpy makes it so strncat's destination
is not NUL terminated.

If you require support for 12-byte model numbers, then
you'll have to increase the length of that buffer
(BFA_FCS_PORT_SYMBNAME_MODEL_SZ) to at least 13.

I've just rebased, and thus confirmed that the patches still apply.

> Here is a v2 patch to which I've added the requisite (char*) cast.
> However, this whole function is rather unreadable due to the
> repetition (12 times!) of "(char *)&port_cfg->sym_name".
> In case someone prefers to factor out that repetition,
> I've appended a larger, v3 patch to do that.
>
> From 4d1ce4e5caf8a5041e5c4f3ae4deddb79c9e247c Mon Sep 17 00:00:00 2001
> From: Jim Meyering <meyering@redhat.com>
> Date: Sun, 29 Apr 2012 10:41:05 +0200
> Subject: [PATCHv2] bfa: avoid buffer overrun for 12-byte model name
>
> we use strncpy to copy a model name of length up to 15 (16, if you count
> the NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
> However, strncpy does not always NUL-terminate, so whenever the original
> model string has strlen >= 12, the following strncat reads beyond end
> of the ->sym_name buffer as it attempts to find end of string.
>
> bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
> {
> 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
> 	...
> 	strncpy((char *)&port_cfg->sym_name, model,
> 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
> 	...
>
> bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
> {
> 	struct bfi_ioc_attr_s	*ioc_attr;
>
> 	WARN_ON(!model);
> 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
>
> BFA_ADAPTER_MODEL_NAME_LEN = 16
>
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  drivers/scsi/bfa/bfa_fcs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index eaac57e..242c37f 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -713,6 +713,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
>  	/* Model name/number */
>  	strncpy((char *)&port_cfg->sym_name, model,
>  		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> +	((char *)&port_cfg->sym_name)[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1] = 0;
>  	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>
> --
> 1.7.12
>
>
> From d7f49a0a2f835ec4808772678fe6c4d595ffa8f5 Mon Sep 17 00:00:00 2001
> From: Jim Meyering <meyering@redhat.com>
> Date: Sun, 29 Apr 2012 10:41:05 +0200
> Subject: [PATCHv3] bfa: avoid buffer overrun for 12-byte model name
>
> we use strncpy to copy a model name of length up to 15 (16, if you count
> the NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
> However, strncpy does not always NUL-terminate, so whenever the original
> model string has strlen >= 12, the following strncat reads beyond end
> of the ->sym_name buffer as it attempts to find end of string.
> Also, factor out the 12 uses of (char *)&port_cfg->sym_name.
>
> bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
> {
> 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
> 	...
> 	strncpy((char *)&port_cfg->sym_name, model,
> 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> 	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
> 	...
>
> bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
> {
> 	struct bfi_ioc_attr_s	*ioc_attr;
>
> 	WARN_ON(!model);
> 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
>
> BFA_ADAPTER_MODEL_NAME_LEN = 16
>
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  drivers/scsi/bfa/bfa_fcs.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index eaac57e..77d08f9 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -707,26 +707,26 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
>  	struct bfa_lport_cfg_s *port_cfg = &fabric->bport.port_cfg;
>  	char model[BFA_ADAPTER_MODEL_NAME_LEN] = {0};
>  	struct bfa_fcs_driver_info_s *driver_info = &fabric->fcs->driver_info;
> +	char *s_name = (char *)&port_cfg->sym_name;
>
>  	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
>
>  	/* Model name/number */
> -	strncpy((char *)&port_cfg->sym_name, model,
> -		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> -	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +	strncpy(s_name, model, BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> +	s_name[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1] = 0;
> +	strncat(s_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>
>  	/* Driver Version */
> -	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
> +	strncat(s_name, (char *)driver_info->version,
>  		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
> -	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +	strncat(s_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>
>  	/* Host machine name */
> -	strncat((char *)&port_cfg->sym_name,
> -		(char *)driver_info->host_machine_name,
> +	strncat(s_name, (char *)driver_info->host_machine_name,
>  		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
> -	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +	strncat(s_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>
>  	/*
> @@ -735,23 +735,18 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
>  	 * OS name string and instead copy the entire OS info string (64 bytes).
>  	 */
>  	if (driver_info->host_os_patch[0] == '\0') {
> -		strncat((char *)&port_cfg->sym_name,
> -			(char *)driver_info->host_os_name,
> +		strncat(s_name, (char *)driver_info->host_os_name,
>  			BFA_FCS_OS_STR_LEN);
> -		strncat((char *)&port_cfg->sym_name,
> -			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +		strncat(s_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>  	} else {
> -		strncat((char *)&port_cfg->sym_name,
> -			(char *)driver_info->host_os_name,
> +		strncat(s_name, (char *)driver_info->host_os_name,
>  			BFA_FCS_PORT_SYMBNAME_OSINFO_SZ);
> -		strncat((char *)&port_cfg->sym_name,
> -			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> +		strncat(s_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
>
>  		/* Append host OS Patch Info */
> -		strncat((char *)&port_cfg->sym_name,
> -			(char *)driver_info->host_os_patch,
> +		strncat(s_name, (char *)driver_info->host_os_patch,
>  			BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ);
>  	}
>
> --
> 1.7.12
