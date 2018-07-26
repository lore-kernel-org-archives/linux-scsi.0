From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Thu, 26 Jul 2018 16:06:05 -0400
Message-ID: <b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83@cybernetics.com>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
	<20180726194209.GB12992@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180726194209.GB12992-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
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

T24gMDcvMjYvMjAxOCAwMzo0MiBQTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4gT24gVGh1LCBK
dWwgMjYsIDIwMTggYXQgMDI6NTQ6NTZQTSAtMDQwMCwgVG9ueSBCYXR0ZXJzYnkgd3JvdGU6Cj4+
IGRtYV9wb29sX2ZyZWUoKSBzY2FsZXMgcG9vcmx5IHdoZW4gdGhlIHBvb2wgY29udGFpbnMgbWFu
eSBwYWdlcyBiZWNhdXNlCj4+IHBvb2xfZmluZF9wYWdlKCkgZG9lcyBhIGxpbmVhciBzY2FuIG9m
IGFsbCBhbGxvY2F0ZWQgcGFnZXMuICBJbXByb3ZlIGl0cwo+PiBzY2FsYWJpbGl0eSBieSByZXBs
YWNpbmcgdGhlIGxpbmVhciBzY2FuIHdpdGggYSByZWQtYmxhY2sgdHJlZSBsb29rdXAuIAo+PiBJ
biBiaWcgTyBub3RhdGlvbiwgdGhpcyBpbXByb3ZlcyB0aGUgYWxnb3JpdGhtIGZyb20gTyhuXjIp
IHRvIE8obiAqIGxvZyBuKS4KPiBUaGlzIGlzIGEgbG90IG9mIGNvZGUgdG8gZ2V0IHVzIHRvIE8o
biAqIGxvZyhuKSkgd2hlbiB3ZSBjYW4gdXNlIGxlc3MKPiBjb2RlIHRvIGdvIHRvIE8obikuICBk
bWFfcG9vbF9mcmVlKCkgaXMgcGFzc2VkIHRoZSB2aXJ0dWFsIGFkZHJlc3MuCj4gV2UgY2FuIGdv
IGZyb20gdmlydHVhbCBhZGRyZXNzIHRvIHN0cnVjdCBwYWdlIHdpdGggdmlydF90b19wYWdlKCku
Cj4gSW4gc3RydWN0IHBhZ2UsIHdlIGhhdmUgNSB3b3JkcyBhdmFpbGFibGUgKDIwLzQwIGJ5dGVz
KSwgYW5kIGl0J3MgdHJpdmlhbAo+IHRvIHVzZSBvbmUgb2YgdGhlbSB0byBwb2ludCB0byB0aGUg
c3RydWN0IGRtYV9wYWdlLgo+ClRoYW5rcyBmb3IgdGhlIHRpcC7CoCBJIHdpbGwgZ2l2ZSB0aGF0
IGEgdHJ5LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpp
b21tdSBtYWlsaW5nIGxpc3QKaW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcKaHR0cHM6
Ly9saXN0cy5saW51eGZvdW5kYXRpb24ub3JnL21haWxtYW4vbGlzdGluZm8vaW9tbXU=
