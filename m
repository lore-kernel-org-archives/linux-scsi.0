From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 24/25] hpsa: add in sas transport class
Date: Fri, 30 Oct 2015 17:00:10 -0500
Message-ID: <5633E86A.8050900@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220656.5323.34704.stgit@brunhilda>
 <04D5BEB2-DCD8-49C7-8BA7-24FD162E5729@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33042 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbbJ3WAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 18:00:12 -0400
Received: by oiad129 with SMTP id d129so67237796oia.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 15:00:11 -0700 (PDT)
In-Reply-To: <04D5BEB2-DCD8-49C7-8BA7-24FD162E5729@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 10/30/2015 03:07 PM, Matthew R. Ochs wrote:
>> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
>>
>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>
>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>> ---
>> drivers/scsi/hpsa.c     |  535 +++++++++++++++++++++++++++++++++++++++++++++--
>> drivers/scsi/hpsa.h     |   27 ++
>> drivers/scsi/hpsa_cmd.h |   14 +
>> 3 files changed, 555 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 56526312..ca38a00 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -41,6 +41,7 @@
>>
>> +static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
>> +						unsigned char *scsi3addr)
>> +{
>> +	struct ReportExtendedLUNdata *physdev;
>> +	u32 nphysicals;
>> +	u64 sa = 0;
>> +	int i;
>> +
>> +	physdev = kzalloc(sizeof(*physdev), GFP_KERNEL);
>> +	if (!physdev)
>> +		return 0;
>> +
>> +	if (hpsa_scsi_do_report_phys_luns(h, physdev, sizeof(*physdev))) {
>> +		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
>> +		kfree(physdev);
>> +		return 0;
>> +	}
>> +	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 24;
>> +
>> +	for (i = 0; i < nphysicals; i++)
>> +		if (!memcmp(&physdev->LUN[i].lunid[0], scsi3addr, 8))
>> +			sa = get_unaligned_be64(&physdev->LUN[i].wwid[0]);
> Don't you want to break out here if you found a match?
Agreed.
>
>> +
>> +	kfree(physdev);
>> +
>> +	return sa;
>> +}
>> +
>> +static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
>> +					struct hpsa_scsi_dev_t *dev)
>> +{
>> +	int rc;
>> +	u64 sa = 0;
>> +
>> +	if (is_hba_lunid(scsi3addr)) {
>> +		struct bmic_sense_subsystem_info *ssi;
>> +
>> +		ssi = kzalloc(sizeof(*ssi), GFP_KERNEL);
> What happens if this allocation fails? If the I/O can succeed without the
> DMA buffer then you will run into trouble when deriving sa.
Added check for NULL.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

