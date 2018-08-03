From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 4/9] dmapool: improve scalability of dma_pool_alloc
Date: Fri, 3 Aug 2018 09:55:17 -0400
Message-ID: <b304d118-8cca-594c-1321-bb65e39700e4@cybernetics.com>
References: <1dbe6204-17fc-efd9-2381-48186cae2b94@cybernetics.com>
	<CAHp75Vdj_jcv3j2pNf4EnzasN9zCJ1f+2aWwT2f5GKG=yFAm4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAHp75Vdj_jcv3j2pNf4EnzasN9zCJ1f+2aWwT2f5GKG=yFAm4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDMvMjAxOCAwNTowMiBBTSwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+IE9uIFRodSwg
QXVnIDIsIDIwMTggYXQgMTA6NTggUE0sIFRvbnkgQmF0dGVyc2J5IDx0b255YkBjeWJlcm5ldGlj
cy5jb20+IHdyb3RlOgo+PiBkbWFfcG9vbF9hbGxvYygpIHNjYWxlcyBwb29ybHkgd2hlbiBhbGxv
Y2F0aW5nIGEgbGFyZ2UgbnVtYmVyIG9mIHBhZ2VzCj4+IGJlY2F1c2UgaXQgZG9lcyBhIGxpbmVh
ciBzY2FuIG9mIGFsbCBwcmV2aW91c2x5LWFsbG9jYXRlZCBwYWdlcyBiZWZvcmUKPj4gYWxsb2Nh
dGluZyBhIG5ldyBvbmUuICBJbXByb3ZlIGl0cyBzY2FsYWJpbGl0eSBieSBtYWludGFpbmluZyBh
IHNlcGFyYXRlCj4+IGxpc3Qgb2YgcGFnZXMgdGhhdCBoYXZlIGZyZWUgYmxvY2tzIHJlYWR5IHRv
IChyZSlhbGxvY2F0ZS4gIEluIGJpZyBPCj4+IG5vdGF0aW9uLCB0aGlzIGltcHJvdmVzIHRoZSBh
bGdvcml0aG0gZnJvbSBPKG5eMikgdG8gTyhuKS4KPj4gIHN0cnVjdCBkbWFfcG9vbCB7ICAgICAg
ICAgICAgICAvKiB0aGUgcG9vbCAqLwo+PiArI2RlZmluZSBQT09MX0ZVTExfSURYICAgMAo+PiAr
I2RlZmluZSBQT09MX0FWQUlMX0lEWCAgMQo+PiArI2RlZmluZSBQT09MX05fTElTVFMgICAgMgo+
PiArICAgICAgIHN0cnVjdCBsaXN0X2hlYWQgcGFnZV9saXN0W1BPT0xfTl9MSVNUU107Cj4gVG8g
YmUgY29uc2lzdGVudCB3aXRoIG5hbWluZyBzY2hlbWUgYW5kIGNvbW1vbiBwcmFjdGljZSBJIHdv
dWxkIHJhdGhlcgo+IG5hbWUgdGhlIGxhc3Qgb25lIGFzCj4KPiBQT09MX01BWF9JRFggMgpPSy4K
Pgo+PiArICAgICAgIElOSVRfTElTVF9IRUFEKCZyZXR2YWwtPnBhZ2VfbGlzdFswXSk7Cj4+ICsg
ICAgICAgSU5JVF9MSVNUX0hFQUQoJnJldHZhbC0+cGFnZV9saXN0WzFdKTsKPiBZb3UgaW50cm9k
dWNlZCBkZWZpbmVzIGFuZCBkb24ndCB1c2UgdGhlbS4KPgpKdXN0IGEgbWF0dGVyIG9mIHN0eWxl
LsKgIEluIHRoaXMgY29udGV4dCwgaXQgb25seSBtYXR0ZXJzIHRoYXQgYm90aAppbmRleCAwIGFu
ZCAxIGdldCBpbml0aWFsaXplZCwgbm90IHdoaWNoIGluZGV4IGNvcnJlc3BvbmRzIHRvIHdoaWNo
Cmxpc3QuwqAgQnV0IEkgc3VwcG9zZSB1c2luZyB0aGUgZGVmaW5lcyB3b3VsZCBpbXByb3ZlIGtl
eXdvcmQgc2VhcmNoLCBzbwpJJ2xsIGNoYW5nZSBpdC4KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlzdAppb21tdUBsaXN0cy5s
aW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91bmRhdGlvbi5vcmcvbWFp
bG1hbi9saXN0aW5mby9pb21tdQ==
