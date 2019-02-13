From: "ira.weiny--- via dri-devel" <dri-devel@lists.freedesktop.org>
Subject: [PATCH V2 6/7] IB/qib: Use the new FOLL_LONGTERM flag to
 get_user_pages_fast()
Date: Wed, 13 Feb 2019 15:04:54 -0800
Message-ID: <20190213230455.5605-7-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190213230455.5605-1-ira.weiny@intel.com>
Reply-To: ira.weiny@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190213230455.5605-1-ira.weiny@intel.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, kvm@vger.kernel.org, linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, linux-mm@kvack.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Martin Brandenburg <martin@omnibond.com>, Rich Felker <dalias@libc.org>, David Hildenbrand <david@redhat.com>, David Airlie <airlied@linux.ie>, Jason Wang <jasowang@redhat.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Michal Hocko <mhocko@suse.com>, Ira Weiny <ira.weiny@intel.com>, Ben Chan <benchan@chromium.org>, Rob Springer <rspringer@google.com>, Todd Poynor <toddpoynor@google.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>, Matt Porter <mporter@kernel.crashing.org>, Wu Hao <hao.wu@intel.com>, Alan Tull <atull@kernel.org>, John Hubbard <jhubbard@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Borislav Petkov <bp@alien8.de>, Alexander Viro <vir>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogSXJhIFdlaW55IDxpcmEud2VpbnlAaW50ZWwuY29tPgoKVXNlIHRoZSBuZXcgRk9MTF9M
T05HVEVSTSB0byBnZXRfdXNlcl9wYWdlc19mYXN0KCkgdG8gcHJvdGVjdCBhZ2FpbnN0CkZTIERB
WCBwYWdlcyBiZWluZyBtYXBwZWQuCgpTaWduZWQtb2ZmLWJ5OiBJcmEgV2VpbnkgPGlyYS53ZWlu
eUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9xaWJfdXNlcl9zZG1h
LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91c2VyX3NkbWEuYyBi
L2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3VzZXJfc2RtYS5jCmluZGV4IDMxYzUyM2Iy
YTlmNS4uYjUzY2MwMjQwZTAyIDEwMDY0NAotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWli
L3FpYl91c2VyX3NkbWEuYworKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91c2Vy
X3NkbWEuYwpAQCAtNjczLDcgKzY3Myw3IEBAIHN0YXRpYyBpbnQgcWliX3VzZXJfc2RtYV9waW5f
cGFnZXMoY29uc3Qgc3RydWN0IHFpYl9kZXZkYXRhICpkZCwKIAkJZWxzZQogCQkJaiA9IG5wYWdl
czsKIAotCQlyZXQgPSBnZXRfdXNlcl9wYWdlc19mYXN0KGFkZHIsIGosIDAsIHBhZ2VzKTsKKwkJ
cmV0ID0gZ2V0X3VzZXJfcGFnZXNfZmFzdChhZGRyLCBqLCBGT0xMX0xPTkdURVJNLCBwYWdlcyk7
CiAJCWlmIChyZXQgIT0gaikgewogCQkJaSA9IDA7CiAJCQlqID0gcmV0OwotLSAKMi4yMC4xCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwg
bWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
