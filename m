From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 4/9] blk-zoned: update blkdev_reset_zones()
 with helper
Date: Mon,  8 Jul 2019 11:47:06 -0700
Message-ID: <20190708184711.2984-5-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: linux-block@vger.kernel.org
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, yuchao0@huawei.com, colyli@suse.de, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-scsi@vger.kernel.org

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBibGtkZXZfcmVzZXRfem9uZXMoKSB3aXRoIG5ld2x5IGlu
dHJvZHVjZWQKaGVscGVyIGZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sg
ZGV2aWNlJ3MgaGRfcGFydHMgd2l0aAp0aGUgaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4K
ClNpZ25lZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5pQHdk
Yy5jb20+Ci0tLQogYmxvY2svYmxrLXpvbmVkLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXpv
bmVkLmMgYi9ibG9jay9ibGstem9uZWQuYwppbmRleCA5ZmFmNDQ4ODMzOWQuLmU3ZjI4NzRiNWQz
NyAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLXpvbmVkLmMKKysrIGIvYmxvY2svYmxrLXpvbmVkLmMK
QEAgLTIyOSw3ICsyMjksNyBAQCBpbnQgYmxrZGV2X3Jlc2V0X3pvbmVzKHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYsCiAJaWYgKGJkZXZfcmVhZF9vbmx5KGJkZXYpKQogCQlyZXR1cm4gLUVQRVJN
OwogCi0JaWYgKCFucl9zZWN0b3JzIHx8IGVuZF9zZWN0b3IgPiBiZGV2LT5iZF9wYXJ0LT5ucl9z
ZWN0cykKKwlpZiAoIW5yX3NlY3RvcnMgfHwgZW5kX3NlY3RvciA+IGJkZXZfbnJfc2VjdHMoYmRl
dikpCiAJCS8qIE91dCBvZiByYW5nZSAqLwogCQlyZXR1cm4gLUVJTlZBTDsKIApAQCAtMjM5LDcg
KzIzOSw3IEBAIGludCBibGtkZXZfcmVzZXRfem9uZXMoc3RydWN0IGJsb2NrX2RldmljZSAqYmRl
diwKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAlpZiAoKG5yX3NlY3RvcnMgJiAoem9uZV9zZWN0b3Jz
IC0gMSkpICYmCi0JICAgIGVuZF9zZWN0b3IgIT0gYmRldi0+YmRfcGFydC0+bnJfc2VjdHMpCisJ
ICAgIGVuZF9zZWN0b3IgIT0gYmRldl9ucl9zZWN0cyhiZGV2KSkKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKIAlibGtfc3RhcnRfcGx1ZygmcGx1Zyk7Ci0tIAoyLjE3LjAKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhl
bi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3Jn
L21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
