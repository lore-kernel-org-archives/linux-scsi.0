From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Wed, 02 Nov 2016 11:44:29 -0400
Message-ID: <1478101469.1001.9.camel@localhost.localdomain>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
         <1478036978-30583-2-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755945AbcKBPog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Nov 2016 11:44:36 -0400
In-Reply-To: <1478036978-30583-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 2016-11-01 at 22:49 +0100, Hannes Reinecke wrote:
...
>  static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>  			char *array_name, u8 *array_id)
>  {
> -	int err, i;
> -	struct c8_inquiry *inqp;
> +	int err = SCSI_DH_IO, i;
> +	struct c8_inquiry *inqp = &h->inq.c8;
>  
> -	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> -	if (err == SCSI_DH_OK) {
> -		inqp = &h->inq.c8;
> +	if (!scsi_get_vpd_page(sdev, 0xC8, (unsigned char *)inqp,
> +			       sizeof(struct c8_inquiry))) {
>  		if (inqp->page_code != 0xc8)
>  			return SCSI_DH_NOSYS;
>  		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
> @@ -453,20 +382,20 @@ static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>  		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
>  		memset(array_id, 0, UNIQUE_ID_LEN);
>  		memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
> +		err = SCSI_DH_OK;
>  	}
>  	return err;
>  }
>  

In this and other places the patch changes the code from submitting the
INQUIRY/EVPD command for the page it wants, to calling scsi_get_vpd_page().
scsi_get_vpd_page() will return -EINVAL if the device did not report in
VPD page 0 that the requested page is in the list of supported pages.
Did you actually verify that the RDAC returns all of these VPD pages in
its VPD page 0 list?

I mean, I know it's supposed to, but these are old devices.

-Ewan


