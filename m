From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Mon, 03 Jan 2005 17:40:10 -0600
Message-ID: <1104795610.5506.75.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230CACD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262079AbVADApq@vger.kernel.org>
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CACD@exa-atlanta>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, brking@us.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-01-03 at 18:02 -0500, Bagalkote, Sreenivas wrote:
> o    Everybody understands that as long as the SCSI scan/rescan is triggered
> by 
> the management app, there is no getting around knowing HCTL mapping. The app
> must know the HCTL quad of a logical drive.

Actually, if that's all you're trying to do, what about

echo '- - -' > /sys/class/scsi_host/host<n>/scan

That'll trigger a rescan of the entire card and the device will be found
and added?

Then, if you simply publish your LD number as an extra parameter of the
device, you can look through /sys to find it.

James
