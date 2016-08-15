From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] ses: use scsi_is_sas_rphy instead of is_sas_attached
Date: Mon, 15 Aug 2016 17:04:39 +0200
Message-ID: <20160815150439.6z7hpjmxty4lespn@c203.arch.suse.de>
References: <201608152258.TcR75AwO%fengguang.wu@intel.com>
 <1471271153.2428.5.camel@linux.vnet.ibm.com>
 <20160815144027.eriee5acsrxsrd52@c203.arch.suse.de>
 <1471273165.2428.7.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471273165.2428.7.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 15, 2016 at 07:59:25AM -0700, James Bottomley wrote:
> On Mon, 2016-08-15 at 16:40 +0200, Johannes Thumshirn wrote:
> > On Mon, Aug 15, 2016 at 07:25:53AM -0700, James Bottomley wrote:
> > > On Mon, 2016-08-15 at 22:11 +0800, kbuild test robot wrote:
> > > > Hi Johannes,
> > > > 
> > > > [auto build test ERROR on scsi/for-next]
> > > > [also build test ERROR on v4.8-rc2 next-20160815]
> > > > [if your patch is applied to the wrong git tree, please drop us a
> > > > note to help improve the system]
> > > 
> > > This is happening because scsi_is_sas_rphy wasn't designed to be 
> > > used outside the SAS transport class, so it's failing when the 
> > > ATTRs aren't defined.
> > > 
> > > This is the way you fix it (needs to be a precursor patch to 1/2):
> > > 
> > > James
> > 
> > Thanks, but I'm wondering about the call to sas_get_address(). It was
> > there before the patch as well and now it's an undefined reference. 
> > Am I missing something here? Sure it can be guarded in the #if block.
> 
> Yes: gcc is kind enough to elide any code that looks like
> 
> if (0) {
> 	refer to something
> }
> 
> So the static inline ensures anything within the brace isn't used as a
> linkable reference.

Aaahhh, that explains a lot.

Anyways, I've included get_sas_address() in the ifdef guard and
compile tested the new series with and with out
CONFIG_SCSI_SAS_ATTRS. Will send out shortly.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
