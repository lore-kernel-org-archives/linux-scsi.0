From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/7] scsi: bfa: use ktime_get_real_ts64 for firmware
	timestamp
Date: Fri, 10 Nov 2017 16:37:09 +0100
Message-ID: <20171110153715.1929456-2-arnd@arndb.de>
References: <20171110153715.1929456-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20171110153715.1929456-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: hare@suse.com, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

QkZBX1RSQ19UUygpIGNhbGN1bGF0ZXMgYSAzMi1iaXQgbWljcm9zZWNvbmQgdGltZXN0YW1wIHVz
aW5nIHRoZQpkZXByZWNhdGVkIGRvX2dldHRpbWVvZmRheSgpIGZ1bmN0aW9uLiBUaGlzIG92ZXJm
bG93cyByb3VnaGx5IGV2ZXJ5CjcxIG1pbnV0ZXMsIHNvIGl0J3Mgb2J2aW91c2x5IG5vdCB1c2Vk
IGFzIGFuIGFic29sdXRlIHRpbWUgc3RhbXAsCmJ1dCBpdCBzZWVtcyB3cm9uZyB0byB1c2UgYSB0
aW1lIGJhc2UgZm9yIGl0IHRoYXQgd2lsbCBqdW1wCmR1cmluZyBzZXR0aW1lb2ZkYXkoKSBjYWxs
cywgbGVhcCBzZWNvbmRzLCBvciB0aGUgeTIwMzggb3ZlcmZsb3cuCgpUaGlzIGNvbnZlcnRzIGl0
IHRvIGt0aW1lX2dldF90czY0KCksIHdoaWNoIGhhcyBub25lIG9mIHRob3NlCnByb2JsZW1zIGJ1
dCBpcyBub3Qgc3luY2hyb25pemVkIHRvIHdhbGwtY2xvY2sgdGltZS4KClNpZ25lZC1vZmYtYnk6
IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+Ci0tLQogZHJpdmVycy9zY3NpL2JmYS9iZmFf
Y3MuaCB8IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9iZmEvYmZhX2NzLmggYi9kcml2ZXJz
L3Njc2kvYmZhL2JmYV9jcy5oCmluZGV4IGRmNjc2MGNhMDkxMS4uOTY4NWVmYzU5YjE2IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3Njc2kvYmZhL2JmYV9jcy5oCisrKyBiL2RyaXZlcnMvc2NzaS9iZmEv
YmZhX2NzLmgKQEAgLTM1LDEwICszNSwxMCBAQAogCiAjZGVmaW5lIEJGQV9UUkNfVFMoX3RyY20p
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKIAkoeyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBcCi0JCXN0cnVjdCB0aW1ldmFsIHR2OyAgICAgICAg
ICAgICAgICAgICAgICBcCisJCXN0cnVjdCB0aW1lc3BlYzY0IHRzOyAgICAgICAgICAgICAgICAg
ICBcCiAJCQkJCQkJXAotCQlkb19nZXR0aW1lb2ZkYXkoJnR2KTsgICAgICAgICAgICAgICAgICAg
XAotCQkodHYudHZfc2VjKjEwMDAwMDArdHYudHZfdXNlYyk7ICAgICAgICAgXAorCQlrdGltZV9n
ZXRfdHM2NCgmdHMpOyAgICAgICAgICAgICAgICAgICAgXAorCQkodHMudHZfc2VjKjEwMDAwMDAr
dHMudHZfbnNlYyAvIDEwMDApOyAgXAogCX0pCiAKICNpZm5kZWYgQkZBX1RSQ19UUwotLSAKMi45
LjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4
IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJv
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
