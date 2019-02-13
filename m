From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V2 3/7] mm/gup: Change GUP fast to use flags
 rather than a write 'bool'
Date: Wed, 13 Feb 2019 16:11:10 -0700
Message-ID: <20190213231110.GD24692@ziepe.ca>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190213230455.5605-1-ira.weiny@intel.com>
 <20190213230455.5605-4-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190213230455.5605-4-ira.weiny@intel.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: ira.weiny@intel.com
Cc: Martin Brandenburg <martin@omnibond.com>, linux-fbdev@vger.kernel.org, Rich Felker <dalias@libc.org>, kvm@vger.kernel.org, linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, rds-devel@oss.oracle.com, Mauro Carvalho Chehab <mchehab@kernel.org>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>, Rob Springer <rspringer@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org, Matt Porter <mporter@kernel.crashing.org>, Jason Wang <jasowang@redhat.com>, devel@lists.orangefs.org
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCBGZWIgMTMsIDIwMTkgYXQgMDM6MDQ6NTFQTSAtMDgwMCwgaXJhLndlaW55QGludGVs
LmNvbSB3cm90ZToKPiBGcm9tOiBJcmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+Cj4gCj4g
VG8gZmFjaWxpdGF0ZSBhZGRpdGlvbmFsIG9wdGlvbnMgdG8gZ2V0X3VzZXJfcGFnZXNfZmFzdCgp
IGNoYW5nZSB0aGUKPiBzaW5ndWxhciB3cml0ZSBwYXJhbWV0ZXIgdG8gYmUgZ3VwX2ZsYWdzLgoK
U28gbm93IHdlIGhhdmU6Cgpsb25nIGdldF91c2VyX3BhZ2VzX3VubG9ja2VkKHVuc2lnbmVkIGxv
bmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgbnJfcGFnZXMsCgkJICAgIHN0cnVjdCBwYWdlICoqcGFn
ZXMsIHVuc2lnbmVkIGludCBndXBfZmxhZ3MpOwoKYW5kIAoKaW50IGdldF91c2VyX3BhZ2VzX2Zh
c3QodW5zaWduZWQgbG9uZyBzdGFydCwgaW50IG5yX3BhZ2VzLAoJCQl1bnNpZ25lZCBpbnQgZ3Vw
X2ZsYWdzLCBzdHJ1Y3QgcGFnZSAqKnBhZ2VzKQoKRG9lcyB0aGlzIG1ha2UgYW55IHNlbnNlPyBB
dCBsZWFzdCB0aGUgYXJndW1lbnRzIHNob3VsZCBiZSBpbiB0aGUgc2FtZQpvcmRlciwgSSB0aGlu
ay4KCkFsc28gdGhpcyBjb21tZW50OgovKgogKiBnZXRfdXNlcl9wYWdlc191bmxvY2tlZCgpIGlz
IHN1aXRhYmxlIHRvIHJlcGxhY2UgdGhlIGZvcm06CiAqCiAqICAgICAgZG93bl9yZWFkKCZtbS0+
bW1hcF9zZW0pOwogKiAgICAgIGdldF91c2VyX3BhZ2VzKHRzaywgbW0sIC4uLiwgcGFnZXMsIE5V
TEwpOwogKiAgICAgIHVwX3JlYWQoJm1tLT5tbWFwX3NlbSk7CiAqCiAqICB3aXRoOgogKgogKiAg
ICAgIGdldF91c2VyX3BhZ2VzX3VubG9ja2VkKHRzaywgbW0sIC4uLiwgcGFnZXMpOwogKgogKiBJ
dCBpcyBmdW5jdGlvbmFsbHkgZXF1aXZhbGVudCB0byBnZXRfdXNlcl9wYWdlc19mYXN0IHNvCiAq
IGdldF91c2VyX3BhZ2VzX2Zhc3Qgc2hvdWxkIGJlIHVzZWQgaW5zdGVhZCBpZiBzcGVjaWZpYyBn
dXBfZmxhZ3MKICogKGUuZy4gRk9MTF9GT1JDRSkgYXJlIG5vdCByZXF1aXJlZC4KICovCgpOZWVk
cyBzb21lIGF0dGVudGlvbiBhcyB0aGUgcmVjb21tZW5kYXRpb24gaXMgbm93IG5vbnNlbnNlLgoK
SG9uZXN0bHkgYSBwcm9wZXIgZXhwbGFuYXRpb24gb2Ygd2h5IHR3byBmdW5jdGlvbnMgZXhpc3Qg
d291bGQgYmUKZ3JlYXQgYXQgdGhpcyBwb2ludCA6KQoKSmFzb24KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVu
LWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcv
bWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
