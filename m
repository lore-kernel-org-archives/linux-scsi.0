From: Matias Bjorling <Matias.Bjorling@wdc.com>
Subject: Re: [PATCH v3 02/11] scsi: sd_zbc: Reduce boot device
 scan and revalidate time
Date: Fri, 12 Oct 2018 10:28:07 +0000
Message-ID: <82d9da13-a8c2-7247-06b5-78d1fff48c3b@wdc.com>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-3-damien.lemoal@wdc.com>
	<d851a895-0340-1d8a-9aa8-1abc902be337@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d851a895-0340-1d8a-9aa8-1abc902be337@suse.de>
Content-Language: en-US
Content-ID: <AC608C24F8760142B859B8025455D437@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hare@suse.de" <hare@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

CgpPbiAxMC8xMi8yMDE4IDA5OjMzIEFNLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4gT24gMTAv
MTIvMTggNDozMCBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4+IEhhbmRsaW5nIGNoZWNrcyBv
ZiBaQkMgZGV2aWNlIGNhcGFjaXR5IHVzaW5nIHRoZSBtYXhfbGJhIGZpZWxkIG9mIHRoZQo+PiBS
RVBPUlQgWk9ORVMgY29tbWFuZCByZXBseSBmb3IgZGlza3Mgd2l0aCByY19iYXNpcyA9PSAwIGNh
biBiZSBkb25lCj4+IHVzaW5nIHRoZSBzYW1lIHJlcG9ydCB6b25lcyBjb21tYW5kIHJlcGx5IHVz
ZWQgdG8gY2hlY2sgdGhlICJzYW1lIgo+PiBmaWVsZC4KPj4KPj4gQXZvaWQgZXhlY3V0aW5nIGEg
cmVwb3J0IHpvbmVzIGNvbW1hbmQgc29sZWx5IHRvIGNoZWNrIHRoZSBkaXNrIGNhcGFjaXR5Cj4+
IGJ5IG1lcmdpbmcgc2RfemJjX2NoZWNrX2NhcGFjaXR5KCkgaW50byBzZF96YmNfY2hlY2tfem9u
ZV9zaXplKCkgYW5kCj4+IHJlbmFtaW5nIHRoYXQgZnVuY3Rpb24gdG8gc2RfemJjX2NoZWNrX3pv
bmVzKCkuIFRoaXMgcmVtb3ZlcyBhIGNvc3RseQo+PiBleGVjdXRpb24gb2YgYSBmdWxsIHJlcG9y
dCB6b25lcyBjb21tYW5kIGFuZCBzbyByZWR1Y2VzIGRldmljZSBzY2FuCj4+IGR1cmF0aW9uIGF0
IGJvb3QgdGltZSBhcyB3ZWxsIGFzIHRoZSBkdXJhdGlvbiBvZiBkaXNrIHJldmFsaWRhdGUgY2Fs
bHMuCj4+Cj4+IEZ1cnRoZXJtb3JlLCBzZXR0aW5nIHRoZSBwYXJ0aWFsIHJlcG9ydCBiaXQgaW4g
dGhlIFJFUE9SVCBaT05FUyBjb21tYW5kCj4+IGNkYiBjYW4gc2lnbmlmaWNhbnRseSByZWR1Y2Ug
dGhpcyBjb21tYW5kIGV4ZWN1dGlvbiB0aW1lIGFzIHRoZSBkZXZpY2UKPj4gZG9lcyBub3QgaGF2
ZSB0byBjb3VudCBhbmQgcmVwb3J0IHRoZSB0b3RhbCBudW1iZXIgb2Ygem9uZXMgdGhhdCBjb3Vs
ZAo+PiBiZSByZXBvcnRlZCBhc3N1bWluZyBhIGxhcmdlIGVub3VnaCByZXBseSBidWZmZXIuIEEg
bm9uLXBhcnRpYWwgem9uZQo+PiByZXBvcnQgaXMgbmVjZXNzYXJ5IG9ubHkgZm9yIHRoZSBmaXJz
dCBleGVjdXRpb24gb2YgcmVwb3J0IHpvbmVzIHVzZWQgdG8KPj4gY2hlY2sgdGhlIHNhbWUgZmll
bGQgdmFsdWUgKHRvIGVuc3VyZSB0aGF0IHRoaXMgdmFsdWUgYXBwbGllcyB0byBhbGwKPj4gem9u
ZXMgb2YgdGhlIGRpc2spLiBBbGwgb3RoZXIgY2FsbHMgdG8gc2RfemJjX3JlcG9ydF96b25lcygp
IGNhbiB1c2UgYQo+PiBwYXJ0aWFsIHJlcG9ydCB0byByZWR1Y2UgZXhlY3V0aW9uIHRpbWUuCj4+
Cj4+IFVzaW5nIGEgMTQgVEIgWkJDIGRpc2ssIHRoZXNlIHNpbXBsZSBjaGFuZ2VzIHJlZHVjZSBk
ZXZpY2Ugc2NhbiB0aW1lIGF0Cj4+IGJvb3QgZnJvbSBhYm91dCAzLjVzIGRvd24gdG8gYWJvdXQg
OTAwbXMuIERpc2sgcmV2YWxpZGF0ZSB0aW1lcyBhcmUgYWxzbwo+PiByZWR1Y2VkIGZyb20gYWJv
dXQgNDUwbXMgZG93biB0byAyMzBtcy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExlIE1v
YWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4KPj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxs
d2lnIDxoY2hAbHN0LmRlPgo+PiAtLS0KPj4gwqAgZHJpdmVycy9zY3NpL3NkX3piYy5jIHwgOTQg
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+PiDCoCAxIGZpbGUg
Y2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgNTQgZGVsZXRpb25zKC0pCj4+Cj4gUmV2aWV3ZWQt
Ynk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4KPgo+IC4uLiBhbmQgaXQnbGwgYmUg
eW91ciBmYXVsdCBpZiB0aGVyZSBhcmUgZHJpdmVzIHdoaWNoIGRvIG5vdCBzdXBwb3J0IAo+IHRo
ZSAncGFydGlhbCcgYml0IDopCj4KCkkgYWxyZWFkeSBsb29rIGZvcndhcmQgdGhlIHF1aXJrIGxp
c3QgOykKCj4gQ2hlZXJzLAo+Cj4gSGFubmVzCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs
