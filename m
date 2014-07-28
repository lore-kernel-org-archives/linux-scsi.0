From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Mon, 28 Jul 2014 18:50:56 +0000
Message-ID: <43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq17g30dprc.fsf@sermon.lab.mkp.net>
	<cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq138dnexcn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:2685
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751702AbaG1Su7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2014 14:50:59 -0400
In-Reply-To: <yq138dnexcn.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Christoph Hellwig <hch@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "apw@canonical.com" <apw@canonical.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Saturday, July 26, 2014 12:25 PM
> To: KY Srinivasan
> Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> >> Great! I'd just like to have a reasonable level of confidence in
> >> what's happening down the stack before I entertain turning something
> >> on that's not being properly advertised.
> 
> KY> As I look at the output of inquiry between Linux on Hyper-V and
> KY> native Linux, is not specifying conformance level the main issue?
> 
> The main problem for this particular use case (aside from the issue we've
> already addressed) is that the passthrough device (SATA SSD) has
> LBPME=0 in the READ CAPACITY(16) response. The LBP VPD is correctly
> provided with LBPU flag set but because LBPME is reported as disabled we
> will not attempt to issue UNMAP commands to the device.

Had a chance to chat with the Windows sscsi folks. Here is their response:

"At the time  thin-provisioning was defined, the discovery information was first proposed in READ CAPACITY 16 command. And then moved into the new dedicated VPD page - B2h. You can see the information reported in this VPD page is richer than READ CAPACITY 16 command. As this transition happened during we added the feature, Windows uses the newer method that based on VPD page B2h. It looks Linux tries to use both new and old method which is weird to me."

Would it make sense for us to work  around this issue for Linux on Hyper-V (just use the VPD page instead of looking at the output of READ CAPACITY)?

Regards,

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
