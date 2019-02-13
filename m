From: "ira.weiny--- via dri-devel" <dri-devel@lists.freedesktop.org>
Subject: [PATCH V2 4/7] mm/gup: Add FOLL_LONGTERM capability to GUP fast
Date: Wed, 13 Feb 2019 15:04:52 -0800
Message-ID: <20190213230455.5605-5-ira.weiny@intel.com>
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

RnJvbTogSXJhIFdlaW55IDxpcmEud2VpbnlAaW50ZWwuY29tPgoKREFYIHBhZ2VzIHdlcmUgcHJl
dmlvdXNseSB1bnByb3RlY3RlZCBmcm9tIGxvbmd0ZXJtIHBpbnMgd2hlbiB1c2VycwpjYWxsZWQg
Z2V0X3VzZXJfcGFnZXNfZmFzdCgpLgoKVXNlIHRoZSBuZXcgRk9MTF9MT05HVEVSTSBmbGFnIHRv
IGNoZWNrIGZvciBERVZNQVAgcGFnZXMgYW5kIGZhbGwKYmFjayB0byByZWd1bGFyIEdVUCBwcm9j
ZXNzaW5nIGlmIGEgREVWTUFQIHBhZ2UgaXMgZW5jb3VudGVyZWQuCgpTaWduZWQtb2ZmLWJ5OiBJ
cmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+Ci0tLQogbW0vZ3VwLmMgfCAyNCArKysrKysr
KysrKysrKysrKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21tL2d1cC5jIGIvbW0vZ3VwLmMKaW5kZXggNmYzMmQz
NmIzYzViLi5mN2U3NTljNTIzYmIgMTAwNjQ0Ci0tLSBhL21tL2d1cC5jCisrKyBiL21tL2d1cC5j
CkBAIC0xNDM5LDYgKzE0MzksOSBAQCBzdGF0aWMgaW50IGd1cF9wdGVfcmFuZ2UocG1kX3QgcG1k
LCB1bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgZW5kLAogCQkJZ290byBwdGVfdW5t
YXA7CiAKIAkJaWYgKHB0ZV9kZXZtYXAocHRlKSkgeworCQkJaWYgKHVubGlrZWx5KGZsYWdzICYg
Rk9MTF9MT05HVEVSTSkpCisJCQkJZ290byBwdGVfdW5tYXA7CisKIAkJCXBnbWFwID0gZ2V0X2Rl
dl9wYWdlbWFwKHB0ZV9wZm4ocHRlKSwgcGdtYXApOwogCQkJaWYgKHVubGlrZWx5KCFwZ21hcCkp
IHsKIAkJCQl1bmRvX2Rldl9wYWdlbWFwKG5yLCBucl9zdGFydCwgcGFnZXMpOwpAQCAtMTU3OCw4
ICsxNTgxLDExIEBAIHN0YXRpYyBpbnQgZ3VwX2h1Z2VfcG1kKHBtZF90IG9yaWcsIHBtZF90ICpw
bWRwLCB1bnNpZ25lZCBsb25nIGFkZHIsCiAJaWYgKCFwbWRfYWNjZXNzX3Blcm1pdHRlZChvcmln
LCBmbGFncyAmIEZPTExfV1JJVEUpKQogCQlyZXR1cm4gMDsKIAotCWlmIChwbWRfZGV2bWFwKG9y
aWcpKQorCWlmIChwbWRfZGV2bWFwKG9yaWcpKSB7CisJCWlmICh1bmxpa2VseShmbGFncyAmIEZP
TExfTE9OR1RFUk0pKQorCQkJcmV0dXJuIDA7CiAJCXJldHVybiBfX2d1cF9kZXZpY2VfaHVnZV9w
bWQob3JpZywgcG1kcCwgYWRkciwgZW5kLCBwYWdlcywgbnIpOworCX0KIAogCXJlZnMgPSAwOwog
CXBhZ2UgPSBwbWRfcGFnZShvcmlnKSArICgoYWRkciAmIH5QTURfTUFTSykgPj4gUEFHRV9TSElG
VCk7CkBAIC0xOTA0LDggKzE5MTAsMjAgQEAgaW50IGdldF91c2VyX3BhZ2VzX2Zhc3QodW5zaWdu
ZWQgbG9uZyBzdGFydCwgaW50IG5yX3BhZ2VzLAogCQlzdGFydCArPSBuciA8PCBQQUdFX1NISUZU
OwogCQlwYWdlcyArPSBucjsKIAotCQlyZXQgPSBnZXRfdXNlcl9wYWdlc191bmxvY2tlZChzdGFy
dCwgbnJfcGFnZXMgLSBuciwgcGFnZXMsCi0JCQkJCSAgICAgIGd1cF9mbGFncyk7CisJCWlmIChn
dXBfZmxhZ3MgJiBGT0xMX0xPTkdURVJNKSB7CisJCQlkb3duX3JlYWQoJmN1cnJlbnQtPm1tLT5t
bWFwX3NlbSk7CisJCQlyZXQgPSBfX2d1cF9sb25ndGVybV9sb2NrZWQoY3VycmVudCwgY3VycmVu
dC0+bW0sCisJCQkJCQkgICAgc3RhcnQsIG5yX3BhZ2VzIC0gbnIsCisJCQkJCQkgICAgcGFnZXMs
IE5VTEwsIGd1cF9mbGFncyk7CisJCQl1cF9yZWFkKCZjdXJyZW50LT5tbS0+bW1hcF9zZW0pOwor
CQl9IGVsc2UgeworCQkJLyoKKwkJCSAqIHJldGFpbiBGQVVMVF9GT0xMX0FMTE9XX1JFVFJZIG9w
dGltaXphdGlvbiBpZgorCQkJICogcG9zc2libGUKKwkJCSAqLworCQkJcmV0ID0gZ2V0X3VzZXJf
cGFnZXNfdW5sb2NrZWQoc3RhcnQsIG5yX3BhZ2VzIC0gbnIsCisJCQkJCQkgICAgICBwYWdlcywg
Z3VwX2ZsYWdzKTsKKwkJfQogCiAJCS8qIEhhdmUgdG8gYmUgYSBiaXQgY2FyZWZ1bCB3aXRoIHJl
dHVybiB2YWx1ZXMgKi8KIAkJaWYgKG5yID4gMCkgewotLSAKMi4yMC4xCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0
CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3Rv
cC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
