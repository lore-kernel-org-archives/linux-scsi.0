From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] mptfusion - fc transport attributes
Date: Tue, 27 Dec 2005 12:15:56 -0500
Message-ID: <43B176CC.2040004@emulex.com>
References: <43A35892.8010802@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55196 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751125AbVL0RQE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Dec 2005 12:16:04 -0500
In-Reply-To: <43A35892.8010802@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Gary Hagensen <gwh@sgi.com>


> +static void
> +mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
> +{
> +	if (timeout > 0)
> +		rport->dev_loss_tmo = timeout;
> +	else
> +		rport->dev_loss_tmo = mptfc_dev_loss_tmo;
> +}

The only function of the if-test here is checking for 0 or >0, as
the fc transport ensures it is nothing else. What bothers me is
if the value is 0, then you are overriding it with the mptfc default
value without any warning or error report to the user.

Perhaps we should be dealing with a zero value differently in the transport.

The rest looks ok...

-- james s
