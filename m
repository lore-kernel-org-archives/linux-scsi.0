From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] mptfusion - fc transport attributes
Date: Fri, 06 Jan 2006 15:23:08 -0600
Message-ID: <43BEDFBC.3010705@sgi.com>
References: <43A35892.8010802@sgi.com> <43B176CC.2040004@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.26]:22661 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S932536AbWAFVXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2006 16:23:17 -0500
In-Reply-To: <43B176CC.2040004@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Gary Hagensen <gwh@sgi.com>

lpfc and qla2x00 have something similar.  I chose the driver default instead of
1.  Is setting it to one correct for the api?

static void
lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
{
        /*
         * The driver doesn't have a per-target timeout setting.  Set
         * this value globally. lpfc_nodev_tmo should be greater then 0.
         */
        if (timeout)
                lpfc_nodev_tmo = timeout;
        else
                lpfc_nodev_tmo = 1;
        rport->dev_loss_tmo = lpfc_nodev_tmo + 5;
}

Mike

James Smart wrote:
> 
>> +static void
>> +mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
>> +{
>> +    if (timeout > 0)
>> +        rport->dev_loss_tmo = timeout;
>> +    else
>> +        rport->dev_loss_tmo = mptfc_dev_loss_tmo;
>> +}
> 
> The only function of the if-test here is checking for 0 or >0, as
> the fc transport ensures it is nothing else. What bothers me is
> if the value is 0, then you are overriding it with the mptfc default
> value without any warning or error report to the user.
> 
> Perhaps we should be dealing with a zero value differently in the
> transport.
> 
> The rest looks ok...
> 
> -- james s
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
