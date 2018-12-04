From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v4 9/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Tue, 4 Dec 2018 11:22:34 -0500
Message-ID: <4dcb22b0-a348-841d-8175-e368f67f33c3@cybernetics.com>
References: <9e65ec2e-5e22-4f65-7b92-ca2af0c555f3@cybernetics.com>
	<20181113063601.GT21824@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181113063601.GT21824-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMTEvMTMvMTggMTozNiBBTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4gT24gTW9uLCBOb3Yg
MTIsIDIwMTggYXQgMTA6NDY6MzVBTSAtMDUwMCwgVG9ueSBCYXR0ZXJzYnkgd3JvdGU6Cj4+IFBy
ZXZlbnQgYSBwb3NzaWJsZSBlbmRsZXNzIGxvb3Agd2l0aCBETUFQT09MX0RFQlVHIGVuYWJsZWQg
aWYgYSBidWdneQo+PiBkcml2ZXIgY29ycnVwdHMgRE1BIHBvb2wgbWVtb3J5Lgo+Pgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBUb255IEJhdHRlcnNieSA8dG9ueWJAY3liZXJuZXRpY3MuY29tPgo+IEkgbGlr
ZSBpdCEgIEFsc28sIGhlcmUgeW91J3JlIHVzaW5nIGJsa3NfcGVyX2FsbG9jIGluIGEgd2F5IHdo
aWNoIGlzbid0Cj4gbm9ybWFsbHkgaW4gdGhlIHBlcmZvcm1hbmNlIHBhdGgsIGJ1dCBtaWdodCBi
ZSB3aXRoIHRoZSByaWdodCBjb25maWcKPiBvcHRpb25zLiAgV2l0aCB0aGF0LCBJIHdpdGhkcmF3
IG15IG9iamVjdGlvbiB0byB0aGUgcHJldmlvdXMgcGF0Y2ggYW5kCj4KPiBBY2tlZC1ieTogTWF0
dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+Cj4KPiBBbmRyZXcsIGNhbiB5b3UgZnVu
bmVsIHRoZXNlIGluIHRocm91Z2ggeW91ciB0cmVlPyAgSWYgeW91J2QgcmF0aGVyIG5vdCwKPiBJ
IGRvbid0IG1pbmQgc3R1ZmZpbmcgdGhlbSBpbnRvIGEgZ2l0IHRyZWUgYW5kIGFza2luZyBMaW51
cyB0byBwdWxsCj4gZm9yIDQuMjEuCj4KTm8gcmVwbHkgZm9yIDMgd2Vla3MsIHNvIGFkZGluZyBB
bmRyZXcgTW9ydG9uIHRvIHJlY2lwaWVudCBsaXN0LgoKQW5kcmV3LCBJIGhhdmUgOSBkbWFwb29s
IHBhdGNoZXMgcmVhZHkgZm9yIG1lcmdpbmcgaW4gNC4yMS7CoCBTZWUgTWF0dGhldwpXaWxjb3gn
cyByZXF1ZXN0IGFib3ZlLgoKVG9ueSBCYXR0ZXJzYnkKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlzdAppb21tdUBsaXN0cy5s
aW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91bmRhdGlvbi5vcmcvbWFp
bG1hbi9saXN0aW5mby9pb21tdQ==
