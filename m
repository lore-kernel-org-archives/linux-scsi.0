From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Fri, 21 Jan 2005 15:58:14 -0800
Message-ID: <1106351894.5932.12.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5705A70B74@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27610 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262624AbVAUX6b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2005 18:58:31 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705A70B74@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>

On Fri, 2005-01-21 at 17:11 -0500, Mukker, Atul wrote:
> All right! The implementation is complete for this and the driver has
> thoroughly gone through testing. Everything looks good except for a minor
> glitch.

That's good news.

> After the new logical drives are created with "- - -" written to the
> scsi_host scan attribute, there is a highly noticeable delay before device
> names (e.g., sda) appears in the /dev directory. If the management
> application tried to access the device immediately after creating new, the
> access fails. Putting a 1 second delay helped, but of course this is not a
> deterministic solution.
> 
> What are the other possibilities?

Well, how about hotplug.  The device addition actually triggers a hot
plug event already (there's no need to add anything, it's done by the
mid-layer), so if you just listen for that, you'll know when the scan
has detected a device.

James


