From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH, RFC] tmscsim: kernel bugzilla bug #2139
Date: Wed, 30 Jun 2004 23:33:21 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406302241200.8236@poirot.grange>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1317591857-1088631201=:8236"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:61155 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262906AbUF3VeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 17:34:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Kostas Papadopoulos <pkostas22@hotmail.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1317591857-1088631201=:8236
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Hello

Short: The attached patch fixes the bug-report #2139 from kernel bugzilla.

Long: The problem is the following: on the second INQUIRY command sent 
with a Tag after the DISCONNECT / RESELECT instead of a MESSAGE-IN phase 
comes directly a DATA-IN phase. This seems a bug in the disk 
implementation, so, a proper fix would, probably, be just including the 
disk in the (tmscsim) black-list, along with 2 more disks (1 of which is 
also SEAGATE), thus disabling Tagged Queues for it. But I wanted to get it 
working as is. Yes, forgot to say - it works under 2.4, where already the 
first INQUIRY is sent with a big buffer. So, the attached patch saves the 
ActiveSRB on RESELECT, for this special case, and then, in DATA-IN phase, 
if it came without a MSG-IN phase, it is restored.

I tried to see what other drivers would do in this case, but didn't come 
up with a single recipe.

Comments are VERY welcome.

Acknowledgements: Kostas Papadopoulos has contributed a disk (SEAGATE 
ST34555N), that exhibits this problem.

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-1317591857-1088631201=:8236
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-bug2139.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.60.0406302333210.8236@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-bug2139.patch"

ZGlmZiAtdSBhL2RyaXZlcnMvc2NzaS9zY3NpaW9tLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaWlvbS5jDQotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaWlvbS5jCVdl
ZCBKdW4gMzAgMjI6MzY6MTIgMjAwNA0KKysrIGIvZHJpdmVycy9zY3NpL3Nj
c2lpb20uYwlXZWQgSnVuIDMwIDIyOjI0OjI5IDIwMDQNCkBAIC04OTAsMTQg
Kzg5MCwyMSBAQA0KIA0KICAgICBpZiAocFNSQiA9PSBwQUNCLT5wVG1wU1JC
KQ0KICAgICB7DQotCWlmIChwRENCKSBwcmludGsgKEtFUk5fRVJSICJEQzM5
MDogcFNSQiA9PSBwVG1wU1JCISAoVGFnUSBFcnJvcj8pICglMDJpLSVpKVxu
IiwNCi0JCQkgIHBEQ0ItPlRhcmdldElELCBwRENCLT5UYXJnZXRMVU4pOw0K
LQllbHNlIHByaW50ayAoS0VSTl9FUlIgIkRDMzkwOiBwU1JCID09IHBUbXBT
UkIhIChUYWdRIEVycm9yPykgKERDQiAwISlcbiIpOw0KLQ0KLQlwU1JCLT5w
U1JCRENCID0gcERDQjsNCi0JZGMzOTBfRW5hYmxlTXNnT3V0X0Fib3J0IChw
QUNCLCBwU1JCKTsNCi0JaWYgKHBEQ0IpIHBEQ0ItPkRDQkZsYWcgfD0gQUJP
UlRfREVWOw0KLQlyZXR1cm47DQorCWlmIChwRENCKSB7DQorCQlwcmludGsg
KEtFUk5fRVJSICJEQzM5MDogcFNSQiA9PSBwVG1wU1JCISAoVGFnUSBFcnJv
cj8pICglMDJpLSVpKVxuIiwNCisJCQlwRENCLT5UYXJnZXRJRCwgcERDQi0+
VGFyZ2V0TFVOKTsNCisJCXBTUkIgPSBwU1JCLT5wTmV4dFNSQjsNCisJCXBB
Q0ItPnBUbXBTUkItPnBOZXh0U1JCID0gTlVMTDsNCisJCXBEQ0ItPnBBY3Rp
dmVTUkIgPSBwU1JCOw0KKwl9IGVsc2Ugew0KKwkJcHJpbnRrIChLRVJOX0VS
UiAiREMzOTA6IHBTUkIgPT0gcFRtcFNSQiEgKFRhZ1EgRXJyb3I/KSAoRENC
IDAhKVxuIik7DQorDQorCQlwU1JCLT5wU1JCRENCID0gcERDQjsNCisJCWRj
MzkwX0VuYWJsZU1zZ091dF9BYm9ydCAocEFDQiwgcFNSQik7DQorCQlpZiAo
cERDQikNCisJCQlwRENCLT5EQ0JGbGFnIHw9IEFCT1JUX0RFVjsNCisJCXJl
dHVybjsNCisJfQ0KICAgICB9DQogDQogICAgIGlmKCBwU1JCLT5TR0luZGV4
IDwgcFNSQi0+U0djb3VudCApDQpAQCAtMTI0Miw2ICsxMjQ5LDcgQEANCiAg
ICAgLyogVGFnUTogV2UgZXhwZWN0IGEgbWVzc2FnZSBzb29uLCBzbyBuZXZl
ciBtaW5kIHRoZSBleGFjdCBTUkIgKi8NCiAgICAgaWYoIHBEQ0ItPlN5bmNN
b2RlICYgRU5fVEFHX1FVRVVFSU5HICkNCiAgICAgew0KKwlwQUNCLT5wVG1w
U1JCLT5wTmV4dFNSQiA9IHBEQ0ItPnBBY3RpdmVTUkI7DQogCXBTUkIgPSBw
QUNCLT5wVG1wU1JCOw0KIAlwRENCLT5wQWN0aXZlU1JCID0gcFNSQjsNCiAg
ICAgfQ0K

---1463811839-1317591857-1088631201=:8236--
