From: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>
Subject: Re: aacraid: Regression in 4.14.56 with *genirq/affinity: assign
 vectors to all possible CPUs*
Date: Fri, 10 Aug 2018 16:11:23 +0200
Message-ID: <29b5f3ce-2c23-bf5e-fe50-29bedd4833e1@molgen.mpg.de>
References: <06ee23fe-ec9e-d67b-b533-d5151be74a11@molgen.mpg.de>
 <20180810133628.GA4131@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070405090907090702080207"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810133628.GA4131@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070405090907090702080207
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear Greg,


On 08/10/18 15:36, Greg Kroah-Hartman wrote:
> On Fri, Aug 10, 2018 at 03:21:52PM +0200, Paul Menzel wrote:
>> Dear Greg,
>>
>>
>> Commit ef86f3a7 (genirq/affinity: assign vectors to all possible CPUs)=
 added
>> for Linux 4.14.56 causes the aacraid module to not detect the attached=
 devices
>> anymore on a Dell PowerEdge R720 with two six core 24x E5-2630 @ 2.30G=
Hz.
>>
>> ```
>> $ dmesg | grep raid
>> [    0.269768] raid6: sse2x1   gen()  7179 MB/s
>> [    0.290069] raid6: sse2x1   xor()  5636 MB/s
>> [    0.311068] raid6: sse2x2   gen()  9160 MB/s
>> [    0.332076] raid6: sse2x2   xor()  6375 MB/s
>> [    0.353075] raid6: sse2x4   gen() 11164 MB/s
>> [    0.374064] raid6: sse2x4   xor()  7429 MB/s
>> [    0.379001] raid6: using algorithm sse2x4 gen() 11164 MB/s
>> [    0.386001] raid6: .... xor() 7429 MB/s, rmw enabled
>> [    0.391008] raid6: using ssse3x2 recovery algorithm
>> [    3.559682] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:=
03 EST 2006)
>> [    3.570061] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 E=
ST 2006)
>> [   10.725767] Adaptec aacraid driver 1.2.1[50834]-custom
>> [   10.731724] aacraid 0000:04:00.0: can't disable ASPM; OS doesn't ha=
ve ASPM control
>> [   10.743295] aacraid: Comm Interface type3 enabled
>> $ lspci -nn | grep Adaptec
>> 04:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8 12G S=
AS/PCIe 3 [9005:028d] (rev 01)
>> 42:00.0 Serial Attached SCSI controller [0107]: Adaptec Smart Storage =
PQI 12G SAS/PCIe 3 [9005:028f] (rev 01)
>> ```
>>
>> But, it still works with a Dell PowerEdge R715 with two eight core AMD=

>> Opteron 6136, the card below.
>>
>> ```
>> $ lspci -nn | grep Adaptec
>> 22:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8 12G S=
AS/PCIe 3 [9005:028d] (rev 01)
>> ```
>>
>> Reverting the commit fixes the issue.
>>
>> commit ef86f3a72adb8a7931f67335560740a7ad696d1d
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Fri Jan 12 10:53:05 2018 +0800
>>
>>     genirq/affinity: assign vectors to all possible CPUs
>>    =20
>>     commit 84676c1f21e8ff54befe985f4f14dc1edc10046b upstream.
>>    =20
>>     Currently we assign managed interrupt vectors to all present CPUs.=
  This
>>     works fine for systems were we only online/offline CPUs.  But in c=
ase of
>>     systems that support physical CPU hotplug (or the virtualized vers=
ion of
>>     it) this means the additional CPUs covered for in the ACPI tables =
or on
>>     the command line are not catered for.  To fix this we'd either nee=
d to
>>     introduce new hotplug CPU states just for this case, or we can sta=
rt
>>     assining vectors to possible but not present CPUs.
>>    =20
>>     Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>     Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>     Tested-by: Stefan Haberland <sth@linux.vnet.ibm.com>
>>     Fixes: 4b855ad37194 ("blk-mq: Create hctx for each present CPU")
>>     Cc: linux-kernel@vger.kernel.org
>>     Cc: Thomas Gleixner <tglx@linutronix.de>
>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> The problem doesn=E2=80=99t happen with Linux 4.17.11, so there are co=
mmits in
>> Linux master fixing this. Unfortunately, my attempts to find out faile=
d.
>>
>> I was able to cherry-pick the three commits below on top of 4.14.62,
>> but the problem persists.
>>
>> 6aba81b5a2f5 genirq/affinity: Don't return with empty affinity masks o=
n error
>> 355d7ecdea35 scsi: hpsa: fix selection of reply queue
>> e944e9615741 scsi: virtio_scsi: fix IO hang caused by automatic irq ve=
ctor affinity
>>
>> Trying to cherry-pick the commits below, referencing the commit
>> in question, gave conflicts.
>>
>> 1. adbe552349f2 scsi: megaraid_sas: fix selection of reply queue
>> 2. d3056812e7df genirq/affinity: Spread irq vectors among present CPUs=
 as far as possible
>>
>> To avoid further trial and error with the server with a slow firmware,=

>> do you know what commits should fix the issue?
>=20
> Look at the email on the stable mailing list:
> 	Subject: Re: Fix for 84676c1f (b5b6e8c8) missing in 4.14.y
> it should help you out here.

Ah, I didn=E2=80=99t see that [1] yet. Also I can=E2=80=99t find the orig=
inal message, and a
way to reply to that thread. Therefore, here is my reply.

> Can you try the patches listed there?

I tried some of these already without success.

b5b6e8c8d3b4 scsi: virtio_scsi: fix IO hang caused by automatic irq vecto=
r affinity
2f31115e940c scsi: core: introduce force_blk_mq
adbe552349f2 scsi: megaraid_sas: fix selection of reply queue

The commit above is already in v4.14.56.

8b834bff1b73 scsi: hpsa: fix selection of reply queue

The problem persists.

The problem also persists with the state below.

3528f73a4e5d scsi: core: introduce force_blk_mq
16dc4d8215f3 scsi: hpsa: fix selection of reply queue
f0a7ab12232d scsi: virtio_scsi: fix IO hang caused by automatic irq vecto=
r affinity
6aba81b5a2f5 genirq/affinity: Don't return with empty affinity masks on e=
rror
1aa1166eface (tag: v4.14.62, stable/linux-4.14.y) Linux 4.14.62

So, some more commits are necessary.


Kind regards,

Paul


[1]: https://www.spinics.net/lists/stable/msg251103.html


--------------ms070405090907090702080207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EFowggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWNMIIEdaADAgECAgwcOtRQhH7u81j4jncwDQYJKoZIhvcNAQELBQAwgZUx
CzAJBgNVBAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1
dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNV
BAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjAeFw0xNjExMDMxNTI0
NDhaFw0zMTAyMjIyMzU5NTlaMGoxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAP
BgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEVMBMG
A1UEAwwMTVBHIENBIC0gRzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnhx4
59Lh4WqgOs/Md04XxU2yFtfM15ZuJV0PZP7BmqSJKLLPyqmOrADfNdJ5PIGBto2JBhtRRBHd
G0GROOvTRHjzOga95WOTeura79T21FWwwAwa29OFnD3ZplQs6HgdwQrZWNi1WHNJxn/4mA19
rNEBUc5urSIpZPvZi5XmlF3v3JHOlx3KWV7mUteB4pwEEfGTg4npPAJbp2o7arxQdoIq+Pu2
OsvqhD7Rk4QeaX+EM1QS4lqd1otW4hE70h/ODPy1xffgbZiuotWQLC6nIwa65Qv6byqlIX0q
Zuu99Vsu+r3sWYsL5SBkgecNI7fMJ5tfHrjoxfrKl/ErTAt8GQIDAQABo4ICBTCCAgEwEgYD
VR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0gBCIwIDANBgsrBgEEAYGt
IYIsHjAPBg0rBgEEAYGtIYIsAQEEMB0GA1UdDgQWBBTEiKUH7rh7qgwTv9opdGNSG0lwFjAf
BgNVHSMEGDAWgBST49gyJtrV8UqlkUrg6kviogzP4TCBjwYDVR0fBIGHMIGEMECgPqA8hjpo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMECgPqA8hjpodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMIHdBggrBgEFBQcBAQSB0DCBzTAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEoGCCsGAQUFBzAChj5odHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABLpeD5FygzqOjj+
/lAOy20UQOGWlx0RMuPcI4nuyFT8SGmK9lD7QCg/HoaJlfU/r78ex+SEide326evlFAoJXIF
jVyzNltDhpMKrPIDuh2N12zyn1EtagqPL6hu4pVRzcBpl/F2HCvtmMx5K4WN1L1fmHWLcSap
dhXLvAZ9RG/B3rqyULLSNN8xHXYXpmtvG0VGJAndZ+lj+BH7uvd3nHWnXEHC2q7iQlDUqg0a
wIqWJgdLlx1Q8Dg/sodv0m+LN0kOzGvVDRCmowBdWGhhusD+duKV66pBl+qhC+4LipariWaM
qK5ppMQROATjYeNRvwI+nDcEXr2vDaKmdbxgDVwwggWvMIIEl6ADAgECAgweKlJIhfynPMVG
/KIwDQYJKoZIhvcNAQELBQAwajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8G
A1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYD
VQQDDAxNUEcgQ0EgLSBHMDIwHhcNMTcxMTE0MTEzNDE2WhcNMjAxMTEzMTEzNDE2WjCBizEL
MAkGA1UEBhMCREUxIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MTQwMgYDVQQL
DCtNYXgtUGxhbmNrLUluc3RpdHV0IGZ1ZXIgbW9sZWt1bGFyZSBHZW5ldGlrMQ4wDAYDVQQL
DAVNUElNRzEUMBIGA1UEAwwLUGF1bCBNZW56ZWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDIh/UR/AX/YQ48VWWDMLTYtXjYJyhRHMc81ZHMMoaoG66lWB9MtKRTnB5lovLZ
enTIUyPsCrMhTqV9CWzDf6v9gOTWVxHEYqrUwK5H1gx4XoK81nfV8oGV4EKuVmmikTXiztGz
peyDmOY8o/EFNWP7YuRkY/lPQJQBeBHYq9AYIgX4StuXu83nusq4MDydygVOeZC15ts0tv3/
6WmibmZd1OZRqxDOkoBbY3Djx6lERohs3IKS6RKiI7e90rCSy9rtidJBOvaQS9wvtOSKPx0a
+2pAgJEVzZFjOAfBcXydXtqXhcpOi2VCyl+7+LnnTz016JJLsCBuWEcB3kP9nJYNAgMBAAGj
ggIxMIICLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFHM0Mc3XjMLlhWpp4JufRELL4A/qMB8GA1UdIwQYMBaA
FMSIpQfuuHuqDBO/2il0Y1IbSXAWMCAGA1UdEQQZMBeBFXBtZW56ZWxAbW9sZ2VuLm1wZy5k
ZTB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1nMi1jYS9w
dWIvY3JsL2NhY3JsLmNybDA4oDagNIYyaHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzIt
Y2EvcHViL2NybC9jYWNybC5jcmwwgc0GCCsGAQUFBwEBBIHAMIG9MDMGCCsGAQUFBzABhido
dHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwQgYIKwYBBQUHMAKGNmh0
dHA6Ly9jZHAxLnBjYS5kZm4uZGUvbXBnLWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBC
BggrBgEFBQcwAoY2aHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzItY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MEAGA1UdIAQ5MDcwDwYNKwYBBAGBrSGCLAEBBDARBg8rBgEEAYGtIYIs
AQEEAwYwEQYPKwYBBAGBrSGCLAIBBAMGMA0GCSqGSIb3DQEBCwUAA4IBAQCQs6bUDROpFO2F
Qz2FMgrdb39VEo8P3DhmpqkaIMC5ZurGbbAL/tAR6lpe4af682nEOJ7VW86ilsIJgm1j0ueY
aOuL8jrN4X7IF/8KdZnnNnImW3QVni6TCcc+7+ggci9JHtt0IDCj5vPJBpP/dKXLCN4M+exl
GXYpfHgxh8gclJPY1rquhQrihCzHfKB01w9h9tWZDVMtSoy9EUJFhCXw7mYUsvBeJwZesN2B
fndPkrXx6XWDdU3S1LyKgHlLIFtarLFm2Hb5zAUR33h+26cN6ohcGqGEEzgIG8tXS8gztEaj
1s2RyzmKd4SXTkKR3GhkZNVWy+gM68J7jP6zzN+cMYIDmjCCA5YCAQEwejBqMQswCQYDVQQG
EwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4
LVBsYW5jay1HZXNlbGxzY2hhZnQxFTATBgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzF
RvyiMA0GCWCGSAFlAwQCAQUAoIIB8TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xODA4MTAxNDExMjNaMC8GCSqGSIb3DQEJBDEiBCADt+CBbbkLA1+GpO5z
T9x3nXculXygqoGPVNw5+2PrXzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MGoxCzAJBgNVBAYTAkRF
MQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEVMBMGA1UEAwwMTVBHIENBIC0gRzAyAgweKlJIhfynPMVG/KIw
gYsGCyqGSIb3DQEJEAILMXygejBqMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREw
DwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTAT
BgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzFRvyiMA0GCSqGSIb3DQEBAQUABIIBAEcA
MkrqUHbhGyGpTLy0SSHV7G2W2nJtQTGcP/A/zo9s+e1Igz0o4MxYnJZJRUmt4ndW0PF/xAnc
VxJvDAcEqFpluDlYDXjMVdQJVr6psC2y4BogtcyRqDl/pMYtntxxUVgzdwmpJ7KpOZ/+QFbR
xw5AZFURoMXKRDEwRerbcpC1bHVdhckUp7mlusIy+SoaqGD6vCnSIZ14p8JusBzqlLlHVYE3
PaLU3ObI++lD+rsmw0qfuAGg1+SMz19iGLbw9ucIEHTSNao1EbClDlinlsXCWonuEEqBX2x0
LP8bsdmNwtxOr8hPiXQKSGYD7uPwkssnkMEHDa2zfYWo7RskBRUAAAAAAAA=
--------------ms070405090907090702080207--
