From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH] scsi: ufs: Check that space was properly alloced in
 copy_query_response
Date: Mon, 3 Jun 2019 08:37:42 +0000
Message-ID: <SN6PR04MB492583D987B1F25A0541EBAFFC140@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <CGME20190521082527epcas1p44fe0c4659549ae265c9d59ef7844e57e@epcas1p4.samsung.com>
        <1558427062-5084-1-git-send-email-avri.altman@wdc.com>
 <cd9f0d7b-8ce6-e432-e1df-c4316b191156@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cd9f0d7b-8ce6-e432-e1df-c4316b191156@samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Avi Shchislowski <Avi.Shchislowski@wdc.com>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

SGkgQWxpbSwNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcuDQpTb3JyeSBmb3IgdGhlIGxhdGUg
cmVzcG9uc2UgLSBJIHdhcyBhd2F5IGZvciBhIGNvdXBsZSBvZiB3ZWVrcy4NCg0KVGhhbmtzLA0K
QXZyaQ0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHNjc2k6IHVmczogQ2hlY2sgdGhhdCBzcGFj
ZSB3YXMgcHJvcGVybHkgYWxsb2NlZCBpbg0KPiBjb3B5X3F1ZXJ5X3Jlc3BvbnNlDQo+IA0KPiBI
aSBBdnJpDQo+IA0KPiBPbiA1LzIxLzE5IDE6NTQgUE0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+
IHN0cnVjdCB1ZnNfZGV2X2NtZCBpcyB0aGUgbWFpbiBjb250YWluZXIgdGhhdCBzdXBwb3J0cyBk
ZXZpY2UgbWFuYWdlbWVudA0KPiA+IGNvbW1hbmRzLiBJbiB0aGUgY2FzZSBvZiBhIHJlYWQgZGVz
Y3JpcHRvciByZXF1ZXN0LCB3ZSBhc3N1bWUgdGhhdCB0aGUNCj4gPiBwcm9wZXIgc3BhY2Ugd2Fz
IGFsbG9jYXRlZCBpbiBkZXZfY21kIHRvIGhvbGQgdGhlIHJldHVybmluZyBkZXNjcmlwdG9yLg0K
PiA+DQo+ID4gVGhpcyBpcyBubyBsb25nZXIgdHJ1ZSwgYXMgdGhlcmUgYXJlIGZsb3dzIHRoYXQg
ZG9lc24ndCB1c2UgZGV2X2NtZA0KPiA+IGZvciBkZXZpY2UgbWFuYWdlbWVudCByZXF1ZXN0cywg
YW5kIHdhcyB3cm9uZyBpbiB0aGUgZmlyc3QgcGxhY2UuDQo+ID4NCj4gQ2FuIHlvdSBwbGVhc2Ug
cHV0IHNvbWUgbGlnaHQgb24gdGhvc2UgZmxvd3M/IEFyZSB0aG9zZSBwbGF0Zm9ybQ0KPiBzcGVj
aWZpYz8gSnVzdCBjdXJpb3VzLg0KTm8sIGFjdHVhbGx5IGl0cyBxdWl0ZSBzaW1wbGlzdGljLg0K
X191ZnNoY2RfcXVlcnlfZGVzY3JpcHRvciBzZXQgZGV2X2NtZC5xdWVyeS5kZXNjcmlwdG9yIA0K
dG8gcG9pbnQgdG8gaXRzIGRlc2lnbmF0ZWQgc3BhY2UgYmVmb3JlIHNlbmRpbmcgdGhlIHJlYWQg
ZGVzY3JpcHRvciBxdWVyeSwNCmFuZCB0byBudWxsIG9uY2UgaXQncyBkb25lLg0KQnV0IGl0IGRv
ZXNuJ3QgY2hlY2sgaXQgaW4gdWZzaGNkX2NvcHlfcXVlcnlfcmVzcG9uc2Ugd2hlbiB0aGUgcXVl
cnkNCnJldHVybnMgZnJvbSB0aGUgZGV2aWNlLCB3aGljaCBpdCBzaG91bGQsIGFzIEkgaW5kaWNh
dGVkIGluIHRoZSBjb21taXQgbG9nLg0KDQoNCj4gVGhpcyBjaGFuZ2UgbG9va3Mgb2sgdG8gbWUu
IEkgaG9wZSB5b3UgaGF2ZSB0ZXN0ZWQgdGhpcyBwYXRjaC4NClllcyBJIGRpZC4NCg0KPiBSZXZp
ZXdlZC1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KDQo=
