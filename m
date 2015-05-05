From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 01/14] lpfc: The lpfc driver does not issue RFF_ID and
 RFT_ID in the correct sequence
Date: Tue, 05 May 2015 15:32:47 -0400
Message-ID: <55491ADF.80102@emulex.com>
References: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com> <20150421132312.00006862@localhost>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62244 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757371AbbEETct (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 15:32:49 -0400
In-Reply-To: <20150421132312.00006862@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org


On 4/21/2015 7:23 AM, Sebastian Herbszt wrote:
> James Smart wrote:
>> The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
>> Signed-off-by: James Smart <james.smart@emulex.com>
>> ---
>>   drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
>> index 2500f15..f2db89f 100644
>> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
>> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
>> @@ -3868,11 +3868,11 @@ out:
>>   
>>   	if (vport->port_state < LPFC_VPORT_READY) {
>>   		/* Link up discovery requires Fabric registration. */
>> -		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0); /* Do this first! */
>>   		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
>>   		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
>>   		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
>>   		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
>> +		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
>>   
>>   		/* Issue SCR just before NameServer GID_FT Query */
>>   		lpfc_issue_els_scr(vport, SCR_DID, 0);
> Can you please elaborate on the correct command order?
> SLI_CTNS_RFF_ID was added last in 2fb9bd8 and moved to the top in
> 92d7f7b with the comment "Do this first!". Now it's moved back.
>
> The libfc code suggests this is correct because it uses the same order.
> qla2xxx on the other hand uses RFT_ID, RFF_ID, RNN_ID, RSNN_NN, but in
> any case RFF_ID follows RFT_ID.
>
> Sebastian

The order (it's a shall, but hard to dictate after the fact) is given in 
FC-SCM - kind of.  SCM indicates what shall be implemented, lists it as 
(a), (b), (c), but actually doesn't say it has to be in that order.  The 
only hard requirement, called out in FCP-4, is that you must register 
your FC-4 Type (via RFT_ID) before registering FC-4 Type Features (via 
RFF_ID), which makes sense. We obviously violated this above and there 
were some switches (or newer fw in them) that enforced it.  The other 
rule of thumbs are: register your data with the switch first, then 
register for SCRs, then do queries about the fabric, with the SCRs 
telling you of changes post the queries.

-- james s


