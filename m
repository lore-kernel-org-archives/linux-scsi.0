From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: avoid buffer overflow when returning sense data
Date: Mon, 15 Oct 2007 15:48:52 +0800
Message-ID: <200710151548.52588.linux@highpoint-tech.com>
References: <200605101704.27491.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com> <200710151442.52230.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.biz.mail.re2.yahoo.com ([206.190.53.9]:24966 "HELO
	smtp110.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752713AbXJOHkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 03:40:25 -0400
In-Reply-To: <200710151442.52230.linux@highpoint-tech.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > 
> > avoid buffer overflow when returning sense data.
> > 
>
> That's really not enough information, sorry.
>
> > index 8b384fa..d32a4a9 100644
> > --- a/drivers/scsi/hptiop.c
> > +++ b/drivers/scsi/hptiop.c
> > @@ -375,8 +375,9 @@ static void hptiop_host_request_callback
> >  		scp->result = SAM_STAT_CHECK_CONDITION;
> >  		memset(&scp->sense_buffer,
> >  				0, sizeof(scp->sense_buffer));
> > -		memcpy(&scp->sense_buffer,
> > -			&req->sg_list, le32_to_cpu(req->dataxfer_length));
> > +		memcpy(&scp->sense_buffer, &req->sg_list,
> > +				min(sizeof(scp->sense_buffer),
> > +					le32_to_cpu(req->dataxfer_length)));
> >  		break;
> >  
> >  	default:
>
> See, we know what the fix does, but we don't know what the consequences are
> if the user's kernel doesn't have this fix.
> 
> So we are not able to work out whether this fix should be backported to
> 2.6.23.x and even to 2.6.22.x?

Sorry for ambiguity. With current adapter firmware the driver is working but future
firmware updates may return sense data larger than 96 bytes, causing overflow
on scp->sense_buffer and a kernel crash.

This fix should be backported to earlier kernels.

HighPoint Linux Team

