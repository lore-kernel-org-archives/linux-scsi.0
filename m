From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: libfc mutex under RCU read section error since "libfc:
 Fixup disc_mutex handling"
Date: Tue, 31 Jul 2018 10:56:07 -0700
Message-ID: <20180731175607.GA1237244@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The libfc and libfcoe modules look to have issues with mutexs being used
under rcu_read_lock, which triggers "Illegal context switch in RCU read
side critical section" warnings under debug kernels.

I started looking at fc_disc.c where rport discovery code appears to
take a mutex for each rport in fc_rport_login/fc_rport_logoff while
being called under rcu_read_lock from fc_disc_done.

With the rdata->kref held, I know rcu_read_unlock can be safely called
before login fc_rport_login/logoff.  But I don't know if it's safe to
then recall rcu_read_lock and simply continue on with the
list_for_each_entry_rcu or not.

And as I start looking into this one case, I also get the same class of
problem popping up in at least libfcoe:fcoe_ctrl.c from
fcoe_ctrl_timer_work as well :(

- Chris Leech
