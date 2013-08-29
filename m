From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [RFC/PATCH 2/3] scsi: ufs: device query status and size check
Date: Thu, 29 Aug 2013 18:09:00 +0300
Message-ID: <00d201cea4c9$b30564e0$19102ea0$@codeaurora.org>
References: <1377788378-5494-1-git-send-email-rshvili@codeaurora.org> <00cc01cea4c9$78be9220$6a3bb660$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00cc01cea4c9$78be9220$6a3bb660$@codeaurora.org>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Raviv Shvili' <rshvili@codeaurora.org>, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Yaniv Gardi
= > Sent: Thursday, August 29, 2013 6:07 PM
= > To: 'Raviv Shvili'; linux-scsi@vger.kernel.org
= > Cc: linux-arm-msm@vger.kernel.org; 'open list'
= > Subject: RE: [RFC/PATCH 2/3] scsi: ufs: device query status and size
check
= > 
= > Looks good to me.
= > Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>
= > 
= > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
= > member of Code Aurora Forum, hosted by The Linux Foundation
= > 
= > 
= > = > -----Original Message-----
= > = > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi- = >
= > owner@vger.kernel.org] On Behalf Of Raviv Shvili = > Sent: Thursday,
= > August 29, 2013 6:00 PM = > To: linux-scsi@vger.kernel.org = > Cc:
linux-
= > arm-msm@vger.kernel.org; Raviv Shvili; open list = > Subject: [RFC/PATCH
= > 2/3] scsi: ufs: device query status and size check = > = > Check query
= > response status before copying the response.
= > = > Add descriptor query response size check, before copying it to
buffer.
= > = >
= > = > Signed-off-by: Raviv Shvili <rshvili@codeaurora.org> = > = > diff
--git
= > a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index = >
= > 6da0d41..d0cad34 100644 = > --- a/drivers/scsi/ufs/ufshcd.c = > +++
= > b/drivers/scsi/ufs/ufshcd.c = > @@ -440,31 +440,35 @@ static inline void
= > ufshcd_query_to_be(struct = > utp_upiu_query *request)
= > = >   * @lrb - pointer to local reference block
= > = >   */
= > = >  static
= > = > -void ufshcd_copy_query_response(struct ufs_hba *hba, struct
= > ufshcd_lrb = > *lrbp) = > +int ufshcd_copy_query_response(struct ufs_hba
= > *hba, struct ufshcd_lrb = > +*lrbp) = >  {
= > = >  	struct ufs_query_res *query_res = &hba-
= > = > >dev_cmd.query.response;
= > = >
= > = > -	/* Get the UPIU response */
= > = > -	query_res->response = ufshcd_get_rsp_upiu_result(lrbp-
= > = > >ucd_rsp_ptr) >>
= > = > -			UPIU_RSP_CODE_OFFSET;
= > = > -
= > = >  	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr,
= > = > QUERY_OSF_SIZE);
= > = >  	ufshcd_query_to_cpu(&query_res->upiu_res);
= > = >
= > = > -
= > = >  	/* Get the descriptor */
= > = >  	if (lrbp->ucd_rsp_ptr->qr.opcode ==
= > = > UPIU_QUERY_OPCODE_READ_DESC) {
= > = >  		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
= > = >  				GENERAL_UPIU_REQUEST_SIZE;
= > = > -		u16 len;
= > = > +		u16 resp_len;
= > = > +		u16 buf_len;
= > = >
= > = >  		/* data segment length */
= > = > -		len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
&
= > = > +		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr-
= > = > >header.dword_2) &
= > = >
= > = > 	MASK_QUERY_DATA_SEG_LEN;
= > = > -
= > = > -		memcpy(hba->dev_cmd.query.descriptor, descp,
= > = > -				min_t(u16, len,
QUERY_DESC_MAX_SIZE));
= > = > +		buf_len =
hba->dev_cmd.query.request.upiu_req.length;
= > = > +		if (likely(buf_len >= resp_len)) {
= > = > +			memcpy(hba->dev_cmd.query.descriptor, descp,
= > = > resp_len);
= > = > +		} else {
= > = > +			dev_warn(hba->dev,
= > = > +				"%s: Response size is bigger than
buffer",
= > = > +				__func__);
= > = > +			return -EINVAL;
= > = > +		}
= > = >  	}
= > = > +
= > = > +	return 0;
= > = >  }
= > = >
= > = >  /**
= > = > @@ -781,11 +785,9 @@ static void
= > = > ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
= > = >  	ufshcd_query_to_be(&ucd_req_ptr->qr);
= > = >
= > = >  	/* Copy the Descriptor */
= > = > -	if ((len > 0) && (query->request.upiu_req.opcode ==
= > = > -
= > = > 	UPIU_QUERY_OPCODE_WRITE_DESC)) {
= > = > -		memcpy(descp, query->descriptor,
= > = > -				min_t(u16, len,
QUERY_DESC_MAX_SIZE));
= > = > -	}
= > = > +	if (query->request.upiu_req.opcode ==
= > = > UPIU_QUERY_OPCODE_WRITE_DESC)
= > = > +		memcpy(descp, query->descriptor, len);
= > = > +
= > = >  }
= > = >
= > = >  static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb
= > *lrbp) = > @@ -964,6 +966,17 @@ ufshcd_clear_cmd(struct ufs_hba *hba,
= > int tag)
= > = >  	return err;
= > = >  }
= > = >
= > = > +static int
= > = > +ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb
= > = > +*lrbp) {
= > = > +	struct ufs_query_res *query_res = &hba-
= > = > >dev_cmd.query.response;
= > = > +
= > = > +	/* Get the UPIU response */
= > = > +	query_res->response = ufshcd_get_rsp_upiu_result(lrbp-
= > = > >ucd_rsp_ptr) >>
= > = > +				UPIU_RSP_CODE_OFFSET;
= > = > +	return query_res->response;
= > = > +}
= > = > +
= > = >  /**
= > = >   * ufshcd_dev_cmd_completion() - handles device management
= > command
= > = > responses
= > = >   * @hba: per adapter instance
= > = > @@ -986,7 +999,9 @@ ufshcd_dev_cmd_completion(struct ufs_hba
= > *hba, = > struct ufshcd_lrb *lrbp)
= > = >  		}
= > = >  		break;
= > = >  	case UPIU_TRANSACTION_QUERY_RSP:
= > = > -		ufshcd_copy_query_response(hba, lrbp);
= > = > +		err = ufshcd_check_query_response(hba, lrbp);
= > = > +		if (!err)
= > = > +			err = ufshcd_copy_query_response(hba, lrbp);
= > = >  		break;
= > = >  	case UPIU_TRANSACTION_REJECT_UPIU:
= > = >  		/* TODO: handle Reject UPIU Response */
= > = > --
= > = > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
= > = > is a member of Code Aurora Forum, hosted by The Linux Foundation = >
= > = > -- = > To unsubscribe from this list: send the line "unsubscribe
linux-scsi"
= > in the = > body of a message to majordomo@vger.kernel.org More
= > majordomo info = > at  http://vger.kernel.org/majordomo-info.html
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html
