From: James.Smart@Emulex.Com
Subject: FW: [PATCH] for Deadlock in transport_fc
Date: Wed, 5 Oct 2005 13:50:08 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4737@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C5C9D5.39B10ABE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54701 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030298AbVJERuZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 13:50:25 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5C9D5.39B10ABE
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

James,

This patch, from a long time ago, has yet to make it into the tree.

-- james s


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
Sent: Wednesday, June 08, 2005 10:57 PM
To: bstroesser@fujitsu-siemens.com; linux-scsi@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] for Deadlock in transport_fc



> currently I'm trying to use the new transport_fc to read the
> very often changing FibreChannel configuration in a test system.
>=20
> To avoid a growing list of consistent binding entries (which
> make no sense in this special case), I tried to switch off this
> feature by
>      "echo none > /sys/class/fc_host/host1/tgtid_bind_type"
>=20
> Unfortunately, the system stalls immediately, I guess the reason
> is store_fc_private_host_tgtid_bind_type() calling
> fc_rport_terminate() while holding host_lock.

Yep. A rather blatant lock bug that slipped through due to testing
on a non-smp box.  Try the attached patch.

>=20
> If I understand the code correctly, even if tgtid_bind_type
> would work correctly, still the rport-nummer and scsi-target-id
> would count up on configuration changes. In the lpfc-driver, I
> saw:
> #define MAX_FCP_TARGET              256     /* max num of FCP=20
> targets supported */
> Will this result in problems after 256 configuration changes?
> If so, what could I do?

Yes, it will. Once the target id assignment became larger than 256,
scsi scans won't see the remote port.

I admit, a more difficult implementation is possible if this is a
goal. In general, a production system will always manage devices
by wwpn assignments, and will usually use fabric zoning to minimize
it's view. Thus, a configuration such as yours, with high variability
in the fabric, is unusual.

I'm open to a different implementation if deemed necessary.

> BTW: My Emulex boards do not recognize a change behind the
> FibreChannel switch. So I force them to scan the configuration
> using "echo [01] >/sys/class/scsi_host/host1/board_online".
> Is there a better way to do this?

This is an issue worth noting. The lpfc driver registers for RSCN
events, so it should be seeing changes. There could be switch issues
in not posting the RSCN's (rare, long-time ago). The driver does
qualify it's nameserver request by FC4 type of FCP. Is the device in
question registering as an FCP type device with the fabric ?
Please follow up on this. This should not be happening.

Also - tweaking the lpfc-specific board_online attribute is a little
odd to make things scan. It resets and restarts the entire adapter.
For a link rescan, we recommend that bounce the link via
"echo 1 > sys/class/scsi_host/host1/issue_lip". If all you needed was
a scsi scan - try "echo "- - -"  > /sys/class/scsi_host/host2/scan ".

-- James


>=20
> Regards
> Bodo
>=20
> P.S.: Please CC me, I'm not on the list.
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

------_=_NextPart_001_01C5C9D5.39B10ABE
Content-Type: application/octet-stream;
	name="patch.fc_xpt"
Content-Transfer-Encoding: base64
Content-Description: patch.fc_xpt
Content-Disposition: attachment;
	filename="patch.fc_xpt"

ZGlmZiAtdXBOciBsaW51eC0yLjYuMTItcmM2L2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9m
Yy5jIGZpeGVkL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9mYy5jCi0tLSBsaW51eC0yLjYu
MTItcmM2L2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9mYy5jCTIwMDUtMDYtMDcgMTU6MTg6
NTguMDAwMDAwMDAwIC0wNDAwCisrKyBmaXhlZC9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRf
ZmMuYwkyMDA1LTA2LTA4IDIyOjQ5OjQyLjAwMDAwMDAwMCAtMDQwMApAQCAtODE3LDEyICs4MTcs
MTUgQEAgc2hvd19mY19wcml2YXRlX2hvc3RfdGd0aWRfYmluZF90eXBlKHN0cgogCXJldHVybiBz
bnByaW50ZihidWYsIEZDX0JJTkRUWVBFX01BWF9OQU1FTEVOLCAiJXNcbiIsIG5hbWUpOwogfQog
CisjZGVmaW5lIGdldF9saXN0X2hlYWRfZW50cnkocG9zLCBoZWFkLCBtZW1iZXIpIAkJXAorCXBv
cyA9IGxpc3RfZW50cnkoKGhlYWQpLT5uZXh0LCB0eXBlb2YoKnBvcyksIG1lbWJlcikKKwogc3Rh
dGljIHNzaXplX3QKIHN0b3JlX2ZjX3ByaXZhdGVfaG9zdF90Z3RpZF9iaW5kX3R5cGUoc3RydWN0
IGNsYXNzX2RldmljZSAqY2RldiwKIAljb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKIHsK
IAlzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IHRyYW5zcG9ydF9jbGFzc190b19zaG9zdChjZGV2
KTsKLQlzdHJ1Y3QgZmNfcnBvcnQgKnJwb3J0LCAqbmV4dF9ycG9ydDsKKwlzdHJ1Y3QgZmNfcnBv
cnQgKnJwb3J0OwogIAllbnVtIGZjX3RndGlkX2JpbmRpbmdfdHlwZSB2YWw7CiAJdW5zaWduZWQg
bG9uZyBmbGFnczsKIApAQCAtODMyLDkgKzgzNSwxMyBAQCBzdG9yZV9mY19wcml2YXRlX2hvc3Rf
dGd0aWRfYmluZF90eXBlKHN0CiAJLyogaWYgY2hhbmdpbmcgYmluZCB0eXBlLCBwdXJnZSBhbGwg
dW51c2VkIGNvbnNpc3RlbnQgYmluZGluZ3MgKi8KIAlpZiAodmFsICE9IGZjX2hvc3RfdGd0aWRf
YmluZF90eXBlKHNob3N0KSkgewogCQlzcGluX2xvY2tfaXJxc2F2ZShzaG9zdC0+aG9zdF9sb2Nr
LCBmbGFncyk7Ci0JCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShycG9ydCwgbmV4dF9ycG9ydCwK
LQkJCQkmZmNfaG9zdF9ycG9ydF9iaW5kaW5ncyhzaG9zdCksIHBlZXJzKQorCQl3aGlsZSAoIWxp
c3RfZW1wdHkoJmZjX2hvc3RfcnBvcnRfYmluZGluZ3Moc2hvc3QpKSkgeworCQkJZ2V0X2xpc3Rf
aGVhZF9lbnRyeShycG9ydCwKKwkJCQkmZmNfaG9zdF9ycG9ydF9iaW5kaW5ncyhzaG9zdCksIHBl
ZXJzKTsKKwkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoc2hvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
OwogCQkJZmNfcnBvcnRfdGVybWluYXRlKHJwb3J0KTsKKwkJCXNwaW5fbG9ja19pcnFzYXZlKHNo
b3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKwkJfQogCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKHNo
b3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAl9CiAK

------_=_NextPart_001_01C5C9D5.39B10ABE--
