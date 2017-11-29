From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 19:11:08 +0000
Message-ID: <1511982666.2671.25.camel@wdc.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <20171129173947.GC20581@kroah.com>
         <1511981395.30220.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:47410 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdK2TLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 14:11:47 -0500
In-Reply-To: <1511981395.30220.6.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <F228D147CE2F17468FF2FEEA74638BC9@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

T24gV2VkLCAyMDE3LTExLTI5IGF0IDEzOjQ5IC0wNTAwLCBFd2FuIEQuIE1pbG5lIHdyb3RlOg0K
PiBiZWNhdXNlIGEgZ2V0IGluc2lkZSBhIGRlc3RydWN0b3Igd291bGQgKmFsd2F5cyogYmUgd3Jv
bmcsIG5vPw0KDQpIZWxsbyBFd2FuLA0KDQpUaGF0J3Mgbm90IHdoYXQgd2UgYXJlIGRpc2N1c3Np
bmcuIFdoYXQgY2FuIGhhcHBlbiB3aXRoIHRoZSBTQ1NJIGNvcmUgaXMgdGhhdA0KZ2V0X2Rldmlj
ZSgpIGlzIGNhbGxlZCBjb25jdXJyZW50bHkgd2l0aCB0aGUgZGVzdHJ1Y3Rvci4gZ2V0X2Rldmlj
ZSgpIGNhbiBiZQ0KY2FsbGVkIGNvbmN1cnJlbnRseSB3aXRoIHRoZSBkZXN0cnVjdG9yIGJlY2F1
c2UgdGhlIGRlc3RydWN0b3JlIHJlbW92ZXMgYQ0KZGV2aWNlIGZyb20gdGhlIHNpYmxpbmdzIGxp
c3QgYW5kIGJlY2F1c2UgdGhlIFNDU0kgY29yZSBjYW4gY2FsbCBnZXRfZGV2aWNlKCkNCmZvciBk
ZXZpY2VzIGl0IGZpbmRzIG9uIHRoZSBzaWJsaW5ncyBsaXN0LiBQZXJzb25hbGx5IEkgdGhpbmsg
dGhhdCBkZXNpZ24gaXMNCnN1cGVyaW9yIGNvbXBhcmVkIHRvIHJlbW92aW5nIGEgU0NTSSBkZXZp
Y2UgZnJvbSB0aGUgc2libGluZyBsaXN0IGJlZm9yZSB0aGUNCmxhc3QgcHV0X2RldmljZSgpIGNh
bGwgYmVjYXVzZSB0aGUgYXBwcm9hY2ggZm9sbG93ZWQgaW4gdGhlIFNDU0kgY29yZSBsZWFkcyB0
bw0KYSBzaW1wbGVyIGltcGxlbWVudGF0aW9uLiBIb3dldmVyLCBpdCBzZWVtcyBsaWtlIHRoZSBj
dXJyZW50IGdldF9kZXZpY2UoKQ0KaW1wbGVtZW50YXRpb24gZG9lcyBub3QgeWV0IHN1cHBvcnQg
dGhlIFNDU0kgY29yZSBkZXNpZ24gLi4uDQoNCkJhcnQu
