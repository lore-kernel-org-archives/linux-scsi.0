From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Tue, 03 Apr 2007 12:08:40 +0900
Message-ID: <4611C538.7050007@gmail.com>
References: <460CDBA6.5030608@gmail.com>	<1175257751.3760.19.camel@mulgrave.il.steeleye.com>	<460D12B8.6050101@gmail.com>	<1175278774.3760.44.camel@mulgrave.il.steeleye.com>	<20070401195943.GA29627@htj.dyndns.org>	<20070402112048.047867c1@gondolin.boeblingen.de.ibm.com> <20070402173443.0a3b5c51@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070402173443.0a3b5c51@gondolin.boeblingen.de.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Cornelia Huck wrote:
> On Mon, 2 Apr 2007 11:20:48 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
>> Cool. However, there's something fishy there (not sure whether it's in
>> your patch or a latent bug in the ccw bus code that just has been
>> uncovered):
> 
> Similar bug when loading/unloading a module that creates a driver
> attribute. The winner seems to be kfree(sd->s_element) in
> release_sysfs_dirent() (in case of an attribute, it will point to the
> attribute structure, which is usually statically created)...

Thanks for finding it out.  I was suspecting that last minute change.
The code should be

if (dir node)
	kfree(s_element)
else if (symlink node)
	do things and kfree()

Thanks.

-- 
tejun
