From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Fri, 27 Jul 2018 17:27:20 -0400
Message-ID: <88d362b7-1d53-b430-1741-b48cbc0a7887@cybernetics.com>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
	<20180726194209.GB12992@bombadil.infradead.org>
	<b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83@cybernetics.com>
	<20180727000708.GA785@bombadil.infradead.org>
	<cae33099-3147-5014-ab4e-c22a4d66dc49@cybernetics.com>
	<20180727152322.GB13348@bombadil.infradead.org>
	<acdc2e32-466c-61d3-145f-80bfba2c6739@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <acdc2e32-466c-61d3-145f-80bfba2c6739-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDcvMjcvMjAxOCAwMzozOCBQTSwgVG9ueSBCYXR0ZXJzYnkgd3JvdGU6Cj4gQnV0IHRoZSBi
aWdnZXIgcHJvYmxlbSBpcyB0aGF0IG15IGZpcnN0IHBhdGNoIGFkZHMgYW5vdGhlciBsaXN0X2hl
YWQgdG8KPiB0aGUgZG1hX3BhZ2UgZm9yIHRoZSBhdmFpbF9wYWdlX2xpbmsgdG8gbWFrZSBhbGxv
Y2F0aW9ucyBmYXN0ZXIuwqAgSQo+IHN1cHBvc2Ugd2UgY291bGQgbWFrZSB0aGUgbGlzdHMgc2lu
Z2x5LWxpbmtlZCBpbnN0ZWFkIG9mIGRvdWJseS1saW5rZWQKPiB0byBzYXZlIHNwYWNlLgo+CgpJ
IG1hbmFnZWQgdG8gcmVkbyBteSBkbWFfcG9vbF9hbGxvYygpIHBhdGNoIHRvIG1ha2UgYXZhaWxf
cGFnZV9saXN0CnNpbmdseS1saW5rZWQgaW5zdGVhZCBvZiBkb3VibHktbGlua2VkLsKgIEJ1dCB0
aGUgcHJvYmxlbSB3aXRoIG1ha2luZwplaXRoZXIgbGlzdCBzaW5nbHktbGlua2VkIGlzIHRoYXQg
aXQgd291bGQgbm8gbG9uZ2VyIGJlIHBvc3NpYmxlIHRvIGNhbGwKcG9vbF9mcmVlX3BhZ2UoKSBh
bnkgdGltZSBvdGhlciB0aGFuIGRtYV9wb29sX2Rlc3Ryb3koKSB3aXRob3V0IHNjYW5uaW5nCnRo
ZSBsaXN0cyB0byByZW1vdmUgdGhlIHBhZ2UgZnJvbSB0aGVtLCB3aGljaCB3b3VsZCBtYWtlIHBy
dW5pbmcKYXJiaXRyYXJ5IGZyZWUgcGFnZXMgc2xvd2VyIChhZGRpbmcgYmFjayBhIE8obl4yKSku
wqAgQnV0IHRoZSBjdXJyZW50CmNvZGUgZG9lc24ndCBkbyB0aGF0IGFueXdheSwgYW5kIGluIGZh
Y3QgaXQgaGFzIGEgY29tbWVudCBpbgpkbWFfcG9vbF9mcmVlKCkgdG8gInJlc2lzdCB0aGUgdGVt
cHRhdGlvbiIgdG8gcHJ1bmUgZnJlZSBwYWdlcy7CoCBBbmQgeWV0Cml0IHNlZW1zIGxpa2UgaXQg
bWlnaHQgYmUgcmVhc29uYWJsZSBmb3Igc29tZW9uZSB0byBhZGQgc3VjaCBjb2RlIGluIHRoZQpm
dXR1cmUgaWYgdGhlcmUgYXJlIGEgd2hvbGUgbG90IG9mIGZyZWUgcGFnZXMsIHNvIEkgYW0gaGVz
aXRhbnQgdG8gbWFrZQppdCBtb3JlIGRpZmZpY3VsdC4KClNvIG15IHF1ZXN0aW9uIGlzOiB3aGVu
IEkgcG9zdCB2MiBvZiB0aGUgcGF0Y2hzZXQsIHNob3VsZCBJIHNlbmQgdGhlCmRvdWJseS1saW5r
ZWQgdmVyc2lvbiBvciB0aGUgc2luZ2x5LWxpbmtlZCB2ZXJzaW9uLCBpbiBhbnRpY2lwYXRpb24g
dGhhdApzb21lb25lIGVsc2UgbWlnaHQgd2FudCB0byB0YWtlIGl0IGZ1cnRoZXIgYW5kIG1vdmUg
ZXZlcnl0aGluZyBpbnRvCnN0cnVjdCBwYWdlIGFzIHlvdSBzdWdnZXN0PwoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KaW9tbXUgbWFpbGluZyBsaXN0Cmlv
bW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnCmh0dHBzOi8vbGlzdHMubGludXhmb3VuZGF0
aW9uLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2lvbW11
