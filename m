From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] libsas: flush pending destruct work in sas_unregister_domain_devices()
Date: Thu, 7 Dec 2017 16:40:17 -0800
Message-ID: <CAM_iQpWL=JQFLV3uuQ1zupZgv=9oGKG4aBBsqrXnmy2ToX=PtQ@mail.gmail.com>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
 <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site> <922397da-7dd3-c24e-1d94-e4804a769331@huawei.com>
 <CAM_iQpVXuO=jHg=wyse7OoGDzLNrz3hFc_aqAPR=FsF_+s5gaw@mail.gmail.com>
 <877cfb17-ba90-da91-a549-418bb6eb6391@huawei.com> <CAM_iQpVWmeq5BMvxJmD2FP6Zm6s7O05+NqzYQ6uCAp7iE1asnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="94eb2c11a142f888dd055fc96ec9"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpVWmeq5BMvxJmD2FP6Zm6s7O05+NqzYQ6uCAp7iE1asnw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

--94eb2c11a142f888dd055fc96ec9
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 7, 2017 at 2:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Dec 7, 2017 at 5:37 AM, John Garry <john.garry@huawei.com> wrote:
>> On 28/11/2017 17:04, Cong Wang wrote:
>>>
>>> I don't understand, the only caller of sas_unregister_domain_devices()
>>> is sas_deform_port().
>>>
>>
>> And sas_deform_port() may be called from another worker on the same queue,
>> right? As in sas_phye_loss_of_signal()->sas_deform_port()
>
> Oh, good catch! I didn't notice this subtle call path.
>
> Do you have any better idea to fix this? We saw this on 4.9 too.
>

I think we can just cancel the destruct work before calling
sas_port_delete(). This should work even if it is called in
another work.

So does the attached (untested) patch make any sense now?

--94eb2c11a142f888dd055fc96ec9
Content-Type: text/plain; charset="US-ASCII"; name="libsas.diff"
Content-Disposition: attachment; filename="libsas.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jax6n0lh0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9saWJzYXMvc2FzX2Rpc2NvdmVyLmMgYi9kcml2ZXJz
L3Njc2kvbGlic2FzL3Nhc19kaXNjb3Zlci5jCmluZGV4IDYwZGU2NjI1MmZhMi4uYmM1MTJkNjVl
MmNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19kaXNjb3Zlci5jCisrKyBi
L2RyaXZlcnMvc2NzaS9saWJzYXMvc2FzX2Rpc2NvdmVyLmMKQEAgLTU2NSw2ICs1NjUsMjEgQEAg
aW50IHNhc19kaXNjb3Zlcl9ldmVudChzdHJ1Y3QgYXNkX3Nhc19wb3J0ICpwb3J0LCBlbnVtIGRp
c2NvdmVyX2V2ZW50IGV2KQogCXJldHVybiAwOwogfQogCitzdGF0aWMgdm9pZCBzYXNfY2FuY2Vs
X3dvcmsoc3RydWN0IHNhc193b3JrICpzdykKK3sKKwljYW5jZWxfd29ya19zeW5jKCZzdy0+d29y
ayk7Cit9CisKK3ZvaWQgc2FzX2NhbmNlbF9ldmVudChzdHJ1Y3QgYXNkX3Nhc19wb3J0ICpwb3J0
LCBlbnVtIGRpc2NvdmVyX2V2ZW50IGV2KQoreworCXN0cnVjdCBzYXNfZGlzY292ZXJ5ICpkaXNj
OworCisJaWYgKCFwb3J0KQorCQlyZXR1cm47CisJZGlzYyA9ICZwb3J0LT5kaXNjOworCXNhc19j
YW5jZWxfd29yaygmZGlzYy0+ZGlzY193b3JrW2V2XS53b3JrKTsKK30KKwogLyoqCiAgKiBzYXNf
aW5pdF9kaXNjIC0tIGluaXRpYWxpemUgdGhlIGRpc2NvdmVyeSBzdHJ1Y3QgaW4gdGhlIHBvcnQK
ICAqIEBwb3J0OiBwb2ludGVyIHRvIHN0cnVjdCBwb3J0CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19wb3J0LmMgYi9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19wb3J0LmMKaW5k
ZXggZDNjNTI5N2M2Yzg5Li44OWUzNzY0MGUyNmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9s
aWJzYXMvc2FzX3BvcnQuYworKysgYi9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19wb3J0LmMKQEAg
LTIxOSw2ICsyMTksNyBAQCB2b2lkIHNhc19kZWZvcm1fcG9ydChzdHJ1Y3QgYXNkX3Nhc19waHkg
KnBoeSwgaW50IGdvbmUpCiAKIAlpZiAocG9ydC0+bnVtX3BoeXMgPT0gMSkgewogCQlzYXNfdW5y
ZWdpc3Rlcl9kb21haW5fZGV2aWNlcyhwb3J0LCBnb25lKTsKKwkJc2FzX2NhbmNlbF9ldmVudChw
b3J0LCBESVNDRV9ERVNUUlVDVCk7CiAJCXNhc19wb3J0X2RlbGV0ZShwb3J0LT5wb3J0KTsKIAkJ
cG9ydC0+cG9ydCA9IE5VTEw7CiAJfSBlbHNlIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvc2NzaS9s
aWJzYXMuaCBiL2luY2x1ZGUvc2NzaS9saWJzYXMuaAppbmRleCA2ZGY2ZmUwYzIxOTguLjViOGE3
ZmFkZDliNCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9zY3NpL2xpYnNhcy5oCisrKyBiL2luY2x1ZGUv
c2NzaS9saWJzYXMuaApAQCAtNjgwLDYgKzY4MCw3IEBAIGludCAgc2FzX2V4X3JldmFsaWRhdGVf
ZG9tYWluKHN0cnVjdCBkb21haW5fZGV2aWNlICopOwogdm9pZCBzYXNfdW5yZWdpc3Rlcl9kb21h
aW5fZGV2aWNlcyhzdHJ1Y3QgYXNkX3Nhc19wb3J0ICpwb3J0LCBpbnQgZ29uZSk7CiB2b2lkIHNh
c19pbml0X2Rpc2Moc3RydWN0IHNhc19kaXNjb3ZlcnkgKmRpc2MsIHN0cnVjdCBhc2Rfc2FzX3Bv
cnQgKik7CiBpbnQgIHNhc19kaXNjb3Zlcl9ldmVudChzdHJ1Y3QgYXNkX3Nhc19wb3J0ICosIGVu
dW0gZGlzY292ZXJfZXZlbnQgZXYpOwordm9pZCBzYXNfY2FuY2VsX2V2ZW50KHN0cnVjdCBhc2Rf
c2FzX3BvcnQgKnBvcnQsIGVudW0gZGlzY292ZXJfZXZlbnQgZXYpOwogCiBpbnQgIHNhc19kaXNj
b3Zlcl9zYXRhKHN0cnVjdCBkb21haW5fZGV2aWNlICopOwogaW50ICBzYXNfZGlzY292ZXJfZW5k
X2RldihzdHJ1Y3QgZG9tYWluX2RldmljZSAqKTsK
--94eb2c11a142f888dd055fc96ec9--
