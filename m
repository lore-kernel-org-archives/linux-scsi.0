From: "Woodhouse, David" <david.woodhouse@intel.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Fri, 11 Apr 2014 09:18:53 +0000
Message-ID: <1397207932.19944.58.camel@shinybook.infradead.org>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	 <1397087425.9519.67.camel@dabdike>
	 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	 <20140410071535.GX13491@8bytes.org>
	 <1397119587.19944.14.camel@shinybook.infradead.org>
	 <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=sha-1;
	protocol="application/x-pkcs7-signature"; boundary="=-UwSvu82BWhPzZe43HCOd"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhe@redhat.com" <bhe@redhat.com>, "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

--=-UwSvu82BWhPzZe43HCOd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-04-10 at 09:19 -0700, Davidlohr Bueso wrote:
> Attaching a dmesg from one of the kernels that boots. It doesn't appear
> to have much of the related information... is there any debug config
> option I can enable that might give you more data?

I'd like the contents of /sys/firmware/acpi/tables/DMAR please. And
please could you also apply this patch to both the last-working and
first-failing kernels and show me the output in both cases?

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index dd576c0..d52ac03 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -683,6 +683,12 @@ static struct intel_iommu *device_to_iommu(int segment=
, u8 bus, u8 devfn)
 out:
 	rcu_read_unlock();
=20
+	if (iommu)
+		printk("Device %x:%02x:%02x.%d on IOMMU at %llx\n", segment, bus,
+		       PCI_SLOT(devfn), PCI_FUNC(devfn), drhd->reg_base_addr);
+	else
+		printk("Device %x:%02x:%02x.%d on no IOMMU\n", segment, bus,
+		       PCI_SLOT(devfn), PCI_FUNC(devfn));
 	return iommu;
 }
=20


--=20
                  Sent with Evolution's ActiveSync support.

David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation





--=-UwSvu82BWhPzZe43HCOd
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
kiW8/Nj6KITQvHqz7x/Es0IRJCc9/zBES7yMeD+fgJKHAEv/uTcFfGM9HIWxPQIDAQABo4IC6jCC
AuYwHQYDVR0OBBYEFGK1Mey+kPYGHowHJ0YXtQU4NmbSMB8GA1UdIwQYMBaAFB5pKrTcKP5HGE4h
Cz+8rBEv8Jj1MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDRB
LmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIHvBggrBgEFBQcBAQSB
4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZp
Y2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MHIG
CCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRp
ZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5jcnQw
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQgwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBCQ4UH3yybC+PzPo7W4PQJQwIDkKfD2i20i/DosQ7+Yeof
KF7qDASe9eoJGXbINBx1u648uOnaMBsxgUUamJo7pdt1ZnsetRtCQrJIsrsJA3Q2MOsrv7xHkzqn
DF99KHEbO2yKvyjJVDznHUWh8M1OFmdoziyWE/VPdqTwXwS/UKO81XaTtWUDGO716HHVlfT9yPle
Ukg2MTcIhhNWmlS8gDUayhteIAlPci71f/oXzXxBiGiO6FVZUEx+rZBQB84Ey0S0Tfm7hiGzoegg
ra0hfiiMOKMio+n0r4NUn03Z+VRUTbdjHIA6Lkozwpadvs9/uK8dIGqfcgxYgk9qdjFPMYICDjCC
AgoCAQEwgYcweTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFy
YTEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJh
c2ljIElzc3VpbmcgQ0EgNEECCmJiMmoAAAAATKAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDQxMTA5MTg1MlowIwYJKoZIhvcNAQkEMRYE
FJqYc1gZdeGXjDFNse95iMAxjL60MA0GCSqGSIb3DQEBAQUABIIBAGJWloVm20xG0aUlqiLcbNB8
oCnXeX6BjIWdlDBR1cyVHVCQLxaEI5o2iIfK2MB81yVd8Kxg2/0aODvqB+D42mIxzAtxPf6QGowJ
9mAoP8uvnIW7ihPRvF6MgXWOF1wknbA9O1Z+DvAPjA7g4X8YSgDYJUwOkVU6f1dJlxA74sGwS75I
6Op2PLaOjiJE41A+Cm9ZykoAenloDymvGsovFfzCQXo8bkXb2TK84EElwdQelt5XV/13xfkn1VJ6
rpUPAOIRD0nWHPMQ0DRRwzerephY1FSS8s2VjiTcizR5QHqgC6FWNM8+HFfeuc7vKCMdCxoz9EBH
SIQ+W4/4hyZcrNkAAAAAAAA=


--=-UwSvu82BWhPzZe43HCOd--
