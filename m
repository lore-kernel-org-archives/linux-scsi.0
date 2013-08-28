From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH v3 2/6] scsi: ufs: fix the setting interrupt aggregation counter
Date: Wed, 28 Aug 2013 15:43:44 +0300
Message-ID: <009901cea3ec$3dc3bb10$b94b3130$@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com> <003701cea26a$347a33a0$9d6e9ae0$%jun@samsung.com> <521C6AEB.3040700@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48334 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3H1Mnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 08:43:49 -0400
In-Reply-To: <521C6AEB.3040700@codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>, 'Seungwon Jeon' <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Subhash Jadavani
= > Sent: Tuesday, August 27, 2013 12:02 PM
= > To: Seungwon Jeon
= > Cc: linux-scsi@vger.kernel.org; 'Vinayak Holikatti'; 'Santosh Y'; 'James E.J.
= > Bottomley'
= > Subject: Re: [PATCH v3 2/6] scsi: ufs: fix the setting interrupt aggregation
= > counter
= > 
= > 
= > Looks good to me.
= > Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
= > 
= > On 8/26/2013 8:10 PM, Seungwon Jeon wrote:
= > > IACTH(Interrupt aggregation counter threshold) value is allowed up to
= > > 0x1F and current setting value is the maximum.
= > > This value is related with NUTRS(max:0x20) of HCI's capability.
= > > Considering HCI controller doesn't support the maximum, IACTH setting
= > > should be adjusted with possible value.
= > > For that, existing 'ufshcd_config_int_aggr' is split into two part
= > > [reset, configure].
= > >
= > > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
= > > Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
= > > ---
= > >   drivers/scsi/ufs/ufshcd.c |   53 +++++++++++++++++++++------------------
= > -----
= > >   drivers/scsi/ufs/ufshci.h |    4 +-
= > >   2 files changed, 27 insertions(+), 30 deletions(-)
= > >
= > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
= > > index 6ff16c9..c90b88a 100644
= > > --- a/drivers/scsi/ufs/ufshcd.c
= > > +++ b/drivers/scsi/ufs/ufshcd.c
= > > @@ -59,6 +59,9 @@
= > >   /* Expose the flag value from utp_upiu_query.value */
= > >   #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
= > >
= > > +/* Interrupt aggregation default timeout, unit: 40us */
= > > +#define INT_AGGR_DEF_TO	0x02
= > > +
= > >   enum {
= > >   	UFSHCD_MAX_CHANNEL	= 0,
= > >   	UFSHCD_MAX_ID		= 1,
= > > @@ -94,12 +97,6 @@ enum {
= > >   	UFSHCD_INT_CLEAR,
= > >   };
= > >
= > > -/* Interrupt aggregation options */
= > > -enum {
= > > -	INT_AGGR_RESET,
= > > -	INT_AGGR_CONFIG,
= > > -};
= > > -
= > >   #define ufshcd_set_eh_in_progress(h) \
= > >   	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS)
= > >   #define ufshcd_eh_in_progress(h) \
= > > @@ -340,30 +337,30 @@ static inline bool
= > ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
= > >   }
= > >
= > >   /**
= > > - * ufshcd_config_int_aggr - Configure interrupt aggregation values.
= > > - *		Currently there is no use case where we want to configure
= > > - *		interrupt aggregation dynamically. So to configure interrupt
= > > - *		aggregation, #define
= > INT_AGGR_COUNTER_THRESHOLD_VALUE and
= > > - *		INT_AGGR_TIMEOUT_VALUE are used.
= > > + * ufshcd_reset_intr_aggr - Reset interrupt aggregation values.
= > >    * @hba: per adapter instance
= > > - * @option: Interrupt aggregation option
= > >    */
= > >   static inline void
= > > -ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
= > > +ufshcd_reset_intr_aggr(struct ufs_hba *hba)
= > >   {
= > > -	switch (option) {
= > > -	case INT_AGGR_RESET:
= > > -		ufshcd_writel(hba, INT_AGGR_ENABLE |
= > > -			      INT_AGGR_COUNTER_AND_TIMER_RESET,
= > > -
= > REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
= > > -		break;
= > > -	case INT_AGGR_CONFIG:
= > > -		ufshcd_writel(hba, INT_AGGR_ENABLE |
= > INT_AGGR_PARAM_WRITE |
= > > -			      INT_AGGR_COUNTER_THRESHOLD_VALUE |
= > > -			      INT_AGGR_TIMEOUT_VALUE,
= > > -
= > REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
= > > -		break;
= > > -	}
= > > +	ufshcd_writel(hba, INT_AGGR_ENABLE |
= > > +		      INT_AGGR_COUNTER_AND_TIMER_RESET,
= > > +		      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
= > > +}
= > > +
= > > +/**
= > > + * ufshcd_config_intr_aggr - Configure interrupt aggregation values.
= > > + * @hba: per adapter instance
= > > + * @cnt: Interrupt aggregation counter threshold
= > > + * @tmout: Interrupt aggregation timeout value  */ static inline void
= > > +ufshcd_config_intr_aggr(struct ufs_hba *hba, u8 cnt, u8 tmout) {
= > > +	ufshcd_writel(hba, INT_AGGR_ENABLE |
= > INT_AGGR_PARAM_WRITE |
= > > +		      INT_AGGR_COUNTER_THLD_VAL(cnt) |
= > > +		      INT_AGGR_TIMEOUT_VAL(tmout),
= > > +		      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
= > >   }
= > >
= > >   /**
= > > @@ -1523,7 +1520,7 @@ static int ufshcd_make_hba_operational(struct
= > ufs_hba *hba)
= > >   	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
= > >
= > >   	/* Configure interrupt aggregation */
= > > -	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
= > > +	ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
= > >
= > >   	/* Configure UTRL and UTMRL base address registers */
= > >   	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
= > > @@ -1971,7 +1968,7 @@ static void ufshcd_transfer_req_compl(struct
= > > ufs_hba *hba)
= > >
= > >   	/* Reset interrupt aggregation counters */
= > >   	if (int_aggr_reset)
= > > -		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
= > > +		ufshcd_reset_intr_aggr(hba);
= > >   }
= > >
= > >   /**
= > > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
= > > index f1e1b74..739ae3a 100644
= > > --- a/drivers/scsi/ufs/ufshci.h
= > > +++ b/drivers/scsi/ufs/ufshci.h
= > > @@ -226,8 +226,8 @@ enum {
= > >
= > >   #define MASK_UIC_COMMAND_RESULT			0xFF
= > >
= > > -#define INT_AGGR_COUNTER_THRESHOLD_VALUE	(0x1F << 8)
= > > -#define INT_AGGR_TIMEOUT_VALUE			(0x02)
= > > +#define INT_AGGR_COUNTER_THLD_VAL(c)	(((c) & 0x1F) << 8)
= > > +#define INT_AGGR_TIMEOUT_VAL(t)		(((t) & 0xFF) << 0)
= > >
= > >   /* Interrupt disable masks */
= > >   enum {
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

