From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild
 test robot
Date: Thu, 28 Jan 2016 11:22:23 -0800
Message-ID: <1454008943.2342.33.camel@HansenPartnership.com>
References: <1453966147-10568-1-git-send-email-kys@microsoft.com>
	 <20160128155613.GA12447@gmail.com>
	 <BY2PR0301MB1654D5EDF0A489A1E212BF6AA0DA0@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49932 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966732AbcA1TW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 14:22:27 -0500
In-Reply-To: <BY2PR0301MB1654D5EDF0A489A1E212BF6AA0DA0@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Olaf Hering <olaf@aepfle.de>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>

On Thu, 2016-01-28 at 19:07 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Thursday, January 28, 2016 7:56 AM
> > To: KY Srinivasan <kys@microsoft.com>
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; 
> > linux-scsi@vger.kernel.org;
> > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > martin.petersen@oracle.com; hare@suse.de
> > Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported
> > by kbuild test
> > robot
> > 
> > On Wed, Jan 27, K. Y. Srinivasan wrote:
> > 
> > > +	depends on SCSI_FC_ATTRS
> > 
> > I think 'depends' instead of 'select' will cause HYPERV_STORAGE to
> > disapepar during make oldconfig if SCSI_FC_ATTRS was not set
> > before.
> > Not sure what the policy of 'depends' vs.  'select' actually is. 
> >  If
> > SCSI_FC_ATTRS is supposed to be a library kind of thing then
> > 'select'
> > might be the correct way.
> 
> The current build issue is because the Hyper-V storage is configured
> to be built with
> the kernel while the SCSI_FC_AATRS is configured as a module. This
> patch fixes that issue.
> I too am not sure what the policy of using "depends" vs " select" is.
> James, what would be your recommendation here.

Oh, you don't care if FC_ATTRS are enabled, but if they are you need to
exclude the case where storvsc is built in but FC_ATTRS is a module? 
 This is the accepted way of doing it:

depends on m || SCSI_FC_ATTRS != m

James

