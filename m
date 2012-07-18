From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 20:17:22 +0300
Message-ID: <20120718171722.GA2347@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com>
	<1342561819.18004.470.camel@haakon2.linux-iscsi.org>
	<5006BD3D.7090104@us.ibm.com>
	<20120718155338.GA21817@infradead.org>
	<20120718160015.GH1777@redhat.com>
	<4872F2B9-F952-48C9-9724-D30239ACD989@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4872F2B9-F952-48C9-9724-D30239ACD989@intel.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2012 at 04:42:33PM +0000, Rustad, Mark D wrote:
> On Jul 18, 2012, at 9:00 AM, Michael S. Tsirkin wrote:
> 
> > On Wed, Jul 18, 2012 at 11:53:38AM -0400, Christoph Hellwig wrote:
> >> On Wed, Jul 18, 2012 at 08:42:21AM -0500, Anthony Liguori wrote:
> >>> 
> >>> If you add support for a new command, you need to provide userspace
> >>> a way to disable this command.  If you change what gets reported for
> >>> VPD, you need to provide userspace a way to make VPD look like what
> >>> it did in a previous version.
> >>> 
> >>> Basically, you need to be able to make a TCM device behave 100% the
> >>> same as it did in an older version of the kernel.
> >>> 
> >>> This is unique to virtualization due to live migration.  If you
> >>> migrate from a 3.6 kernel to a 3.8 kernel, you need to make sure
> >>> that the 3.8 kernel's TCM device behaves exactly like the 3.6 kernel
> >>> because the guest that is interacting with it does not realize that
> >>> live migration happened.
> >> 
> >> I don't think these strict live migration rules apply to SCSI targets.
> >> 
> >> Real life storage systems get new features and different behaviour with
> >> firmware upgrades all the time, and SCSI initiators deal with that just
> >> fine.
> >> I don't see any reason to be more picky just because we're
> >> virtualized.
> > 
> > Presumably initiators are shut down for target firmware upgrades?
> > With virtualization your host can change without guest shutdown.
> > You can also *lose* commands when migrating to an older host.
> 
> 
> Actually no. Storage vendors do not want to impose a need to take initiators down for any reason. I have worked for a storage system vendor that routinely did firmware upgrades on-the-fly. This is done by multi-pathing and taking one path down, upgrade, bring up, repeat.

With live migration even that does not happen.

> There was even one non-redundant system that I am aware of that could upgrade firmware and reboot fast enough that the initiators would not notice.
> 
> You do have to pay very close attention to some things however. Don't change the device identity in any way - even version information, otherwise a Windows initiator will blue-screen. I made that mistake myself, so I remember it well. It seemed like such an innocent change. I don't recall there being any issue with adding commands and we did do that on occasion.

How about removing commands?

> -- 
> Mark Rustad, LAN Access Division, Intel Corporation
