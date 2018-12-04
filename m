From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v4 9/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Tue, 4 Dec 2018 16:26:51 -0500
Message-ID: <495c7e22-9332-1654-9ee0-63c33fae980e@cybernetics.com>
References: <9e65ec2e-5e22-4f65-7b92-ca2af0c555f3@cybernetics.com>
	<20181113063601.GT21824@bombadil.infradead.org>
	<4dcb22b0-a348-841d-8175-e368f67f33c3@cybernetics.com>
	<20181204121443.1430883634a6ecf5f4a6a4a2@linux-foundation.org>
	<20181204201801.GS10377@bombadil.infradead.org>
	<CAHp75VeCHnUcE8mfUkx_uXz9_ZoA+hAvVtFiFP+nLj4rJevBdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAHp75VeCHnUcE8mfUkx_uXz9_ZoA+hAvVtFiFP+nLj4rJevBdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMTIvNC8xOCAzOjMwIFBNLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6Cj4gT24gVHVlLCBEZWMg
NCwgMjAxOCBhdCAxMDoxOCBQTSBNYXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4g
d3JvdGU6Cj4+IE9uIFR1ZSwgRGVjIDA0LCAyMDE4IGF0IDEyOjE0OjQzUE0gLTA4MDAsIEFuZHJl
dyBNb3J0b24gd3JvdGU6Cj4+PiBBbHNvLCBBbmR5IGhhZCBpc3N1ZXMgd2l0aCB0aGUgdjIgc2Vy
aWVzIHNvIGl0IHdvdWxkIGJlIGdvb2QgdG8gaGVhciBhbgo+Pj4gdXBkYXRlIGZyb20gaGltPwo+
PiBDZXJ0YWlubHkuCj4gSG1tLi4uIEkgY2VydGFpbmx5IGZvcmdvdCB3aGF0IHdhcyBsb25nIHRp
bWUgYWdvLgo+IElmIEkgX3dhc18gaW4gQ2MgbGlzdCBhbmQgZGlkbid0IGNvbW1lbnQsIEknbSBm
aW5lIHdpdGggaXQuCj4KdjQgb2YgdGhlIHBhdGNoc2V0IGlzIHRoZSBzYW1lIGFzIHYzIGJ1dCB3
aXRoIHRoZSBsYXN0IHBhdGNoIGRyb3BwZWQuwqAKQW5keSBoYWQgb25seSBvbmUgbWlub3IgY29t
bWVudCBvbiB2MyBhYm91dCB0aGUgdXNlIG9mIGRpdmlzaW9uIGluIHBhdGNoCiM4LCB0byB3aGlj
aCBJIHJlcGxpZWQuwqAgVGhhdCB3YXMgYmFjayBvbiBBdWd1c3QgOC4KClRvbnkKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlz
dAppb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91
bmRhdGlvbi5vcmcvbWFpbG1hbi9saXN0aW5mby9pb21tdQ==
