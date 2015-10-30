From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 24/25] hpsa: add in sas transport class
Date: Fri, 30 Oct 2015 18:23:26 -0500
Message-ID: <3406D9A5-4302-41F0-94C6-6946C1D76DE0@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220656.5323.34704.stgit@brunhilda> <04D5BEB2-DCD8-49C7-8BA7-24FD162E5729@linux.vnet.ibm.com> <5633E86A.8050900@pmcs.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:56069 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270AbbJ3XXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 19:23:31 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 17:23:30 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id CFBD91FF002D
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 17:11:40 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UNM45u3342746
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 16:22:04 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UNNSpU029893
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 17:23:28 -0600
In-Reply-To: <5633E86A.8050900@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 30, 2015, at 5:00 PM, Don Brace <brace77070@gmail.com> wrote:
> On 10/30/2015 03:07 PM, Matthew R. Ochs wrote:
>>> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
>>> 
>>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>> 
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>> drivers/scsi/hpsa.c     |  535 +++++++++++++++++++++++++++++++++++++++++++++--
>>> drivers/scsi/hpsa.h     |   27 ++
>>> drivers/scsi/hpsa_cmd.h |   14 +
>>> 3 files changed, 555 insertions(+), 21 deletions(-)
>>> 
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index 56526312..ca38a00 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -41,6 +41,7 @@
>>> 
>>> +static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
>>> +						unsigned char *scsi3addr)
>>> +{
>>> +	struct ReportExtendedLUNdata *physdev;
>>> +	u32 nphysicals;
>>> +	u64 sa = 0;
>>> +	int i;
>>> +
>>> +	physdev = kzalloc(sizeof(*physdev), GFP_KERNEL);
>>> +	if (!physdev)
>>> +		return 0;
>>> +
>>> +	if (hpsa_scsi_do_report_phys_luns(h, physdev, sizeof(*physdev))) {
>>> +		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
>>> +		kfree(physdev);
>>> +		return 0;
>>> +	}
>>> +	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 24;
>>> +
>>> +	for (i = 0; i < nphysicals; i++)
>>> +		if (!memcmp(&physdev->LUN[i].lunid[0], scsi3addr, 8))
>>> +			sa = get_unaligned_be64(&physdev->LUN[i].wwid[0]);
>> Don't you want to break out here if you found a match?
> Agreed.
>> 
>>> +
>>> +	kfree(physdev);
>>> +
>>> +	return sa;
>>> +}
>>> +
>>> +static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
>>> +					struct hpsa_scsi_dev_t *dev)
>>> +{
>>> +	int rc;
>>> +	u64 sa = 0;
>>> +
>>> +	if (is_hba_lunid(scsi3addr)) {
>>> +		struct bmic_sense_subsystem_info *ssi;
>>> +
>>> +		ssi = kzalloc(sizeof(*ssi), GFP_KERNEL);
>> What happens if this allocation fails? If the I/O can succeed without the
>> DMA buffer then you will run into trouble when deriving sa.
> Added check for NULL.

With these changes

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

