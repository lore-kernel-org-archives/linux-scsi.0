From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Fri, 11 Aug 2017 15:37:39 +0000
Message-ID: <1502465858.2428.1.camel@wdc.com>
References: <20170803214014.20332-1-bart.vanassche@wdc.com>
         <yq14ltj9sjd.fsf@oracle.com> <8760dvn273.fsf@concordia.ellerman.id.au>
         <1502378800.2309.5.camel@wdc.com> <87r2widict.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31274 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbdHKPi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2017 11:38:29 -0400
In-Reply-To: <87r2widict.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Content-ID: <E6DDD9202205B1479186A63AAF94227C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mpe@ellerman.id.au" <mpe@ellerman.id.au>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "bjking1@us.ibm.com" <bjking1@us.ibm.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "inuxppc-dev@lists.ozlabs.org" <inuxppc-dev@lists.ozlabs.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

T24gRnJpLCAyMDE3LTA4LTExIGF0IDExOjA1ICsxMDAwLCBNaWNoYWVsIEVsbGVybWFuIHdyb3Rl
Og0KPiBrd29ya2VyL3UxOTM6MCAgRDEyNzM2ICAgICA2ICAgICAgMiAweDAwMDAwODAwDQo+IFdv
cmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuDQo+IENhbGwgVHJhY2U6
DQo+IFtjMDAwMDAwM2Y3NTk3NDEwXSBbYzAwMDAwMDAwMDE1MGQwMF0gY29uc29sZV91bmxvY2sr
MHgzMzAvMHg3NzAgKHVucmVsaWFibGUpDQo+IFtjMDAwMDAwM2Y3NTk3NWUwXSBbYzAwMDAwMDAw
MDAxYjNiOF0gX19zd2l0Y2hfdG8rMHgyYTgvMHg0NjANCj4gW2MwMDAwMDAzZjc1OTc2NDBdIFtj
MDAwMDAwMDAwOWFiYzYwXSBfX3NjaGVkdWxlKzB4MzIwLzB4YWEwDQo+IFtjMDAwMDAwM2Y3NTk3
NzEwXSBbYzAwMDAwMDAwMDlhYzQyMF0gc2NoZWR1bGUrMHg0MC8weGIwDQo+IFtjMDAwMDAwM2Y3
NTk3NzQwXSBbYzAwMDAwMDAwMDliMDlkNF0gc2NoZWR1bGVfdGltZW91dCsweDI1NC8weDQ0MA0K
PiBbYzAwMDAwMDNmNzU5NzgyMF0gW2MwMDAwMDAwMDA5YWNhODBdIGlvX3NjaGVkdWxlX3RpbWVv
dXQrMHgzMC8weDYwDQo+IFtjMDAwMDAwM2Y3NTk3ODUwXSBbYzAwMDAwMDAwMDlhZDc1Y10gd2Fp
dF9mb3JfY29tbW9uX2lvLmNvbnN0cHJvcC4yKzB4YmMvMHgxZTANCj4gW2MwMDAwMDAzZjc1OTc4
ZDBdIFtjMDAwMDAwMDAwNTA5ZTZjXSBibGtfZXhlY3V0ZV9ycSsweDRjLzB4NzANCj4gW2MwMDAw
MDAzZjc1OTc5MjBdIFtjMDAwMDAwMDAwNjU0YWJjXSBzY3NpX2V4ZWN1dGUrMHhmYy8weDI2MA0K
PiBbYzAwMDAwMDNmNzU5Nzk5MF0gW2MwMDAwMDAwMDA2NTRmOThdIHNjc2lfbW9kZV9zZW5zZSsw
eDIxOC8weDQxMA0KPiBbYzAwMDAwMDNmNzU5N2FhMF0gW2MwMDAwMDAwMDA2OGVlNjhdIHNkX3Jl
dmFsaWRhdGVfZGlzaysweDkwOC8weDFjZDANCj4gW2MwMDAwMDAzZjc1OTdiZTBdIFtjMDAwMDAw
MDAwNjkwNDM0XSBzZF9wcm9iZV9hc3luYysweGI0LzB4MjIwDQo+IFtjMDAwMDAwM2Y3NTk3YzYw
XSBbYzAwMDAwMDAwMDExMGEyMF0gYXN5bmNfcnVuX2VudHJ5X2ZuKzB4NzAvMHgxNzANCj4gW2Mw
MDAwMDAzZjc1OTdjYTBdIFtjMDAwMDAwMDAwMTAzOTA0XSBwcm9jZXNzX29uZV93b3JrKzB4MmI0
LzB4NTYwDQo+IFtjMDAwMDAwM2Y3NTk3ZDMwXSBbYzAwMDAwMDAwMDEwM2MzOF0gd29ya2VyX3Ro
cmVhZCsweDg4LzB4NWEwDQo+IFtjMDAwMDAwM2Y3NTk3ZGMwXSBbYzAwMDAwMDAwMDEwYmZjY10g
a3RocmVhZCsweDE1Yy8weDFhMA0KPiBbYzAwMDAwMDNmNzU5N2UzMF0gW2MwMDAwMDAwMDAwMGJh
MWNdIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHg1Yy8weGMwDQoNCkhlbGxvIE1pY2hhZWwsDQoN
Ckl0IGlzIHN1c3BpY2lvdXMgdGhhdCBlbnRyaWVzIGxpa2UgdGhlIGFib3ZlIGFwcGVhciBpbiB0
aGUgU3lzUnEtdyBvdXRwdXQuDQpFdmVyeSB0aW1lIEkgc2F3IHRoaXMgaW4gdGhlIHBhc3QgaXQg
d2FzIGNhdXNlZCBieSBhIGJsb2NrIGRyaXZlciBub3QgaGF2aW5nDQpjYWxsZWQgYmxrX2VuZF9y
ZXF1ZXN0KCkgb3IgYSBTQ1NJIExMRCBub3QgaGF2aW5nIGNhbGxlZCAuc2NzaV9kb25lKCkuDQpB
ZGRpdGlvbmFsbHksIGl0IGlzIHVubGlrZWx5IHRoYXQgdGhlIHBhdGNoIGF0IHRoZSBzdGFydCBv
ZiB0aGlzIHRocmVhZA0KaW50cm9kdWNlZCB0aGlzIGlzc3VlLiBDYW4geW91IGhhdmUgYW5vdGhl
ciBsb29rIGF0IHRoZSBpcHIgZHJpdmVyPyBJZiBhDQpzaGVsbCBpcyBhdmFpbGFibGUgYXQgdGhl
IHRpbWUgdGhpcyBsb2NrdXAgb2NjdXJzLCBpdCB3aWxsIHByb2JhYmx5IGJlDQpoZWxwZnVsIHRv
IGhhdmUgYSBsb29rIGF0IHRoZSBkZWJ1Z2ZzIGVudHJpZXMgdW5kZXIgL3N5cy9rZXJuZWwvZGVi
dWcvYmxvY2svLg0KDQpUaGFua3MsDQoNCkJhcnQu
