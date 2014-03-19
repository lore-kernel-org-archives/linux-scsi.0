From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH -next] libata.h: add stub for ata_sas_port_resume
Date: Wed, 19 Mar 2014 11:14:15 -0700
Message-ID: <1395252855.21554.1.camel@dwillia2-mobl2.amr.corp.intel.com>
References: <5329D7F1.4030400@infradead.org>
	 <20140319175852.GD19874@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140319175852.GD19874@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jim Davis <jim.epost@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-03-19 at 13:58 -0400, Tejun Heo wrote:
> On Wed, Mar 19, 2014 at 10:46:25AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Fix build error when CONFIG_PM is not enabled by adding a stub
> > function in <linux/libata.h>.
> > 
> > drivers/scsi/libsas/sas_ata.c: In function 'sas_resume_sata':
> > drivers/scsi/libsas/sas_ata.c:756:3: error: implicit declaration of function 'ata_sas_port_resume' [-Werror=implicit-function-declaration]
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > ---
> >  include/linux/libata.h |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- linux-next-20140319.orig/include/linux/libata.h
> > +++ linux-next-20140319/include/linux/libata.h
> > @@ -1148,6 +1148,9 @@ static inline void ata_sas_port_suspend(
> >  static inline void ata_sas_port_async_resume(struct ata_port *ap)
> >  {
> >  }
> > +static inline void ata_sas_port_resume(struct ata_port *ap)
> > +{
> > +}
> >  #endif
> >  extern int ata_ratelimit(void);
> >  extern void ata_msleep(struct ata_port *ap, unsigned int msecs);
> 
> Applied to libata/for-3.15.
> 
> Thanks.

Agh, my mistake... one more incremental fixlet:

8<--------------
Subject: libata: remove unused ata_sas_port_async_resume() stub

From: Dan Williams <dan.j.williams@intel.com>

Commit bc6e7c4b0d1a "libata, libsas: kill pm_result and related cleanup"
renamed ata_sas_port_async_resume() to ata_sas_port_resume(), but missed
a CONFIG_PM=n stub conversion.  Randy fixed that up in commit
a5a6569959fc "libata.h: add stub for ata_sas_port_resume", but missed
the deletion of the now unused ata_sas_port_async_resume() routine.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/libata.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 52723789b991..1de36be64df4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1145,9 +1145,6 @@ extern void ata_sas_port_resume(struct ata_port *ap);
 static inline void ata_sas_port_suspend(struct ata_port *ap)
 {
 }
-static inline void ata_sas_port_async_resume(struct ata_port *ap)
-{
-}
 static inline void ata_sas_port_resume(struct ata_port *ap)
 {
 }


