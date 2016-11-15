From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Tue, 15 Nov 2016 16:39:33 +0100
Message-ID: <20161115153933.ktho6pui7awuvfyx@linux-x5ow.site>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
 <20161025074313.4ma4czgdj46imaei@linux-x5ow.site>
 <20161115115622.j4ker3atejcodqrc@linux-x5ow.site>
 <8647eacd-a029-dff0-4f78-dafef89a5ad9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8647eacd-a029-dff0-4f78-dafef89a5ad9@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>s
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 15, 2016 at 03:31:27PM +0100, Steffen Maier wrote:
> Hi Johannes,
> 
> On 11/15/2016 12:56 PM, Johannes Thumshirn wrote:
> > On Tue, Oct 25, 2016 at 09:43:14AM +0200, Johannes Thumshirn wrote:
> > > On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
> > > > On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> > > > > Hm, still behaves for me like I reported for v2:
> > > > > http://marc.info/?l=linux-scsi&m=147637177902937&w=2
> > 
> > [...]
> > 
> > > > 
> > > > The rational behind this is, in fc_req_to_bsgjob() we're assigning
> > > > job->request as req->cmd and job->request_len = req->cmd_len. But without
> > > > checkinf job->request_len we don't know whether we're save to touch
> > > > job->request (a.k.a. bsg_request).
> > > 
> > > Hi Steffen,
> > > Did you have any chance testing this? I hacked fcping to work with non-FCoE
> > > and rports as well and tested with FCoE and lpfc. No problems seen from my
> > > side. I've also pused the series (With this change folded in) to my git
> > > tree at [1] if this helps you in any way.
> > > 
> > > [1] https://git.kernel.org/cgit/linux/kernel/git/jth/linux.git/log/?h=scsi-bsg-rewrite-v4
> > > 
> > 
> > So I finally have a test system up and running. I have good and bad news. The
> > good news is, I can't get the system crashing with my patches, the bad news is
> > I can't get zfcp_ping and zfcp_show to output something but HBA_STATUS_ERROR
> > with my patches and without.

Please ignore my last mails, apparently it's a wise idea to check which user
id one has before running zfcp_ping...

The good news for this is, I can now recreate the crashes you have and thus
have a chance to fix them :-)

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
