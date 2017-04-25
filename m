From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 05/37] smartpqi: ensure controller is in SIS mode at init
Date: Tue, 25 Apr 2017 19:57:53 +0000
Message-ID: <1493150271.2628.9.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314958226.13903.4820392053805213524.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37633 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176113AbdDYT55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 15:57:57 -0400
In-Reply-To: <149314958226.13903.4820392053805213524.stgit@brunhilda>
Content-Language: en-US
Content-ID: <8CEFFA02867A884CB134D01C80530391@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> +bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
> +{
> +	u32 status;
> +	bool kernel_up;
> +
> +	status =3D readl(&ctrl_info->registers->sis_firmware_status);
> +
> +	if (status & SIS_CTRL_KERNEL_UP)
> +		kernel_up =3D true;
> +	else
> +		kernel_up =3D false;
> +
> +	return kernel_up;
> +}

Since bool is a synonym for the C11 type _Bool, it is not necessary to
convert explicitly to a truth value. The above code can be simplified into:

bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
{
	return readl(&ctrl_info->registers->sis_firmware_status) &
		SIS_CTRL_KERNEL_UP;
}=
