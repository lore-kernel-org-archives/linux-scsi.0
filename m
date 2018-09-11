From: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>
Subject: Re: aacraid: Regression in 4.14.56 with *genirq/affinity: assign
 vectors to all possible CPUs*
Date: Tue, 11 Sep 2018 12:53:54 +0200
Message-ID: <cbd7cb64-dbfe-e085-e80b-67dad4084d69@molgen.mpg.de>
References: <06ee23fe-ec9e-d67b-b533-d5151be74a11@molgen.mpg.de>
 <20180810133628.GA4131@kroah.com>
 <29b5f3ce-2c23-bf5e-fe50-29bedd4833e1@molgen.mpg.de>
 <20180810155511.GA17092@kroah.com>
 <f5c57bf7-b8c1-a560-d13a-d74e0f27adbb@molgen.mpg.de>
 <20180811135021.GA2186@kroah.com> <20180813033157.GA18254@ming.t460p>
 <89f2b622-3d2a-04ce-a6d1-ffb5d9612763@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090600010600070709030702"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <89f2b622-3d2a-04ce-a6d1-ffb5d9612763@molgen.mpg.de>
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090600010600070709030702
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear Ming, dear Raghava, dear Dave,


On 08/16/18 19:09, Paul Menzel wrote:

> On 08/13/18 05:32, Ming Lei wrote:
>> On Sat, Aug 11, 2018 at 03:50:21PM +0200, Greg Kroah-Hartman wrote:
>>> On Sat, Aug 11, 2018 at 10:14:18AM +0200, Paul Menzel wrote:
>=20
>>>> Am 10.08.2018 um 17:55 schrieb Greg Kroah-Hartman:
>>>>> On Fri, Aug 10, 2018 at 04:11:23PM +0200, Paul Menzel wrote:
>>>>
>>>>>> On 08/10/18 15:36, Greg Kroah-Hartman wrote:
>>>>>>> On Fri, Aug 10, 2018 at 03:21:52PM +0200, Paul Menzel wrote:
>=20
>>>>>>>> Commit ef86f3a7 (genirq/affinity: assign vectors to all possible=
 CPUs) added
>>>>>>>> for Linux 4.14.56 causes the aacraid module to not detect the at=
tached devices
>>>>>>>> anymore on a Dell PowerEdge R720 with two six core 24x E5-2630 @=
 2.30GHz.
>>>>>>>>
>>>>>>>> ```
>>>>>>>> $ dmesg | grep raid
>>>>>>>> [    0.269768] raid6: sse2x1   gen()  7179 MB/s
>>>>>>>> [    0.290069] raid6: sse2x1   xor()  5636 MB/s
>>>>>>>> [    0.311068] raid6: sse2x2   gen()  9160 MB/s
>>>>>>>> [    0.332076] raid6: sse2x2   xor()  6375 MB/s
>>>>>>>> [    0.353075] raid6: sse2x4   gen() 11164 MB/s
>>>>>>>> [    0.374064] raid6: sse2x4   xor()  7429 MB/s
>>>>>>>> [    0.379001] raid6: using algorithm sse2x4 gen() 11164 MB/s
>>>>>>>> [    0.386001] raid6: .... xor() 7429 MB/s, rmw enabled
>>>>>>>> [    0.391008] raid6: using ssse3x2 recovery algorithm
>>>>>>>> [    3.559682] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 =
00:01:03 EST 2006)
>>>>>>>> [    3.570061] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:3=
2:35 EST 2006)
>>>>>>>> [   10.725767] Adaptec aacraid driver 1.2.1[50834]-custom
>>>>>>>> [   10.731724] aacraid 0000:04:00.0: can't disable ASPM; OS does=
n't have ASPM control
>>>>>>>> [   10.743295] aacraid: Comm Interface type3 enabled
>>>>>>>> $ lspci -nn | grep Adaptec
>>>>>>>> 04:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8=
 12G SAS/PCIe 3 [9005:028d] (rev 01)
>>>>>>>> 42:00.0 Serial Attached SCSI controller [0107]: Adaptec Smart St=
orage PQI 12G SAS/PCIe 3 [9005:028f] (rev 01)
>>>>>>>> ```
>>>>>>>>
>>>>>>>> But, it still works with a Dell PowerEdge R715 with two eight co=
re AMD
>>>>>>>> Opteron 6136, the card below.
>>>>>>>>
>>>>>>>> ```
>>>>>>>> $ lspci -nn | grep Adaptec
>>>>>>>> 22:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8=
 12G SAS/PCIe 3 [9005:028d] (rev 01)
>>>>>>>> ```
>>>>>>>>
>>>>>>>> Reverting the commit fixes the issue.
>>>>>>>>
>>>>>>>> commit ef86f3a72adb8a7931f67335560740a7ad696d1d
>>>>>>>> Author: Christoph Hellwig <hch@lst.de>
>>>>>>>> Date:   Fri Jan 12 10:53:05 2018 +0800
>>>>>>>>
>>>>>>>>      genirq/affinity: assign vectors to all possible CPUs
>>>>>>>>      commit 84676c1f21e8ff54befe985f4f14dc1edc10046b upstream.
>>>>>>>>      Currently we assign managed interrupt vectors to all presen=
t CPUs.  This
>>>>>>>>      works fine for systems were we only online/offline CPUs.  B=
ut in case of
>>>>>>>>      systems that support physical CPU hotplug (or the virtualiz=
ed version of
>>>>>>>>      it) this means the additional CPUs covered for in the ACPI =
tables or on
>>>>>>>>      the command line are not catered for.  To fix this we'd eit=
her need to
>>>>>>>>      introduce new hotplug CPU states just for this case, or we =
can start
>>>>>>>>      assining vectors to possible but not present CPUs.
>>>>>>>>      Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>=

>>>>>>>>      Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>>>>>      Tested-by: Stefan Haberland <sth@linux.vnet.ibm.com>
>>>>>>>>      Fixes: 4b855ad37194 ("blk-mq: Create hctx for each present =
CPU")
>>>>>>>>      Cc: linux-kernel@vger.kernel.org
>>>>>>>>      Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>>>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>>>>>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg>
>>>>>>>>
>>>>>>>> The problem doesn=E2=80=99t happen with Linux 4.17.11, so there =
are commits in
>>>>>>>> Linux master fixing this. Unfortunately, my attempts to find out=
 failed.
>>>>>>>>
>>>>>>>> I was able to cherry-pick the three commits below on top of 4.14=
=2E62,
>>>>>>>> but the problem persists.
>>>>>>>>
>>>>>>>> 6aba81b5a2f5 genirq/affinity: Don't return with empty affinity m=
asks on error
>>>>>>>> 355d7ecdea35 scsi: hpsa: fix selection of reply queue
>>>>>>>> e944e9615741 scsi: virtio_scsi: fix IO hang caused by automatic =
irq vector affinity
>>>>>>>>
>>>>>>>> Trying to cherry-pick the commits below, referencing the commit
>>>>>>>> in question, gave conflicts.
>>>>>>>>
>>>>>>>> 1. adbe552349f2 scsi: megaraid_sas: fix selection of reply queue=

>>>>>>>> 2. d3056812e7df genirq/affinity: Spread irq vectors among presen=
t CPUs as far as possible
>>>>>>>>
>>>>>>>> To avoid further trial and error with the server with a slow fir=
mware,
>>>>>>>> do you know what commits should fix the issue?
>>>>>>>
>>>>>>> Look at the email on the stable mailing list:
>>>>>>> 	Subject: Re: Fix for 84676c1f (b5b6e8c8) missing in 4.14.y
>>>>>>> it should help you out here.
>>>>>>
>>>>>> Ah, I didn=E2=80=99t see that [1] yet. Also I can=E2=80=99t find t=
he original message, and a
>>>>>> way to reply to that thread. Therefore, here is my reply.
>>>>>>
>>>>>>> Can you try the patches listed there?
>>>>>>
>>>>>> I tried some of these already without success.
>>>>>>
>>>>>> b5b6e8c8d3b4 scsi: virtio_scsi: fix IO hang caused by automatic ir=
q vector affinity
>>>>>> 2f31115e940c scsi: core: introduce force_blk_mq
>>>>>> adbe552349f2 scsi: megaraid_sas: fix selection of reply queue
>>>>>>
>>>>>> The commit above is already in v4.14.56.
>>>>>>
>>>>>> 8b834bff1b73 scsi: hpsa: fix selection of reply queue
>>>>>>
>>>>>> The problem persists.
>>>>>>
>>>>>> The problem also persists with the state below.
>>>>>>
>>>>>> 3528f73a4e5d scsi: core: introduce force_blk_mq
>>>>>> 16dc4d8215f3 scsi: hpsa: fix selection of reply queue
>>>>>> f0a7ab12232d scsi: virtio_scsi: fix IO hang caused by automatic ir=
q vector affinity
>>>>>> 6aba81b5a2f5 genirq/affinity: Don't return with empty affinity mas=
ks on error
>>>>>> 1aa1166eface (tag: v4.14.62, stable/linux-4.14.y) Linux 4.14.62
>>>>>>
>>>>>> So, some more commits are necessary.
>>>>>
>>>>> Or I revert the original patch here, and the follow-on ones that we=
re
>>>>> added to "fix" this issue.  I think that might be the better thing
>>>>> overall here, right?  Have you tried that?
>>>>
>>>> Yes, reverting the commit fixed the issue for us. If Christoph or Mi=
ng do
>>>> not have another suggestion for a commit, that would be the way to g=
o.
>>>
>>> Christoph or Ming, any ideas here?
>>>
>>> In looking at the aacraid code, I don't see anywhere that this is usi=
ng
>>> a specific cpu number for queues or anything, but I could be wrong.
>>> Ideally this should also be failing in 4.17 or 4.18-rc right now as w=
ell
>>> as I don't see anything that would have "fixed" this recently.  Unles=
s
>>> I'm missing something here?
>>
>> From both aac_fib_vector_assign() and aac_src_deliver_message(), looks=

>> every msix vector is used inside driver, so causes this trouble.
>>
>> From 84676c1f21e8ff54b (genirq/affinity: assign vectors to all possibl=
e CPUs),
>> actually it should have been since 9a0ef98e18 (genirq/affinity: Assign=
 vectors
>> to all present CPUs), it isn't guaranteed that one vector can be mappe=
d to
>> at least one online CPU.
>>
>> So it should be fixed in driver by similar approach taken in the
>> following patches:
>> 	scsi: hpsa: fix selection of reply queue
>> 	scsi: megaraid_sas: fix selection of reply queue
>>
>> And the reason this issue won't be observed is that the following
>> patches(merged to v4.17) may avoid this issue, but in theory, the issu=
e
>> won't be avoided completely by these patches:
>>
>> d3056812e7df genirq/affinity: Spread irq vectors among present CPUs as=
 far as possible
>> 1a2d0914e23a genirq/affinity: Allow irq spreading from a given startin=
g point
>> b3e6aaa8d94d genirq/affinity: Move actual irq vector spreading into a =
helper function
>> 47778f33dcba genirq/affinity: Rename *node_to_possible_cpumask as *nod=
e_to_cpumask
>> 0211e12dd0a5 genirq/affinity: Don't return with empty affinity masks o=
n error
>>
>> In short, this issue should have been fixed in upstream aacraid, and t=
he idea
>> is simple, use the current CPU id to retrieve the msix vector offset, =
this
>> way will make sure that the msix vector can be mapped from one online
>> CPU.
>=20
> AACRAID folks, are you going to work on that? I looked at the code a bi=
t,
> and it=E2=80=99ll take me some days to understand it and to fix it.

Unfortunately, there was no reply yet and I won=E2=80=99t be able to fix =
it any
time soon. The aacraid driver is still broken in 4.14.68. Reverting the
*one* mentioned commit fixes the issue.

Raghava, Dave, are you aware of the issue.

> Just out of curiosity, shouldn=E2=80=99t the subsystems(?) communicate =
better to
> avoid such breakage, or was that unexpected?


Kind regards,

Paul


--------------ms090600010600070709030702
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
SIb3DQEJBTEPFw0xODA5MTExMDUzNTRaMC8GCSqGSIb3DQEJBDEiBCAo0DQYCyDHixNgf7gW
ZsEOlJtKAj9JJXZ53e8m525pZzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MGoxCzAJBgNVBAYTAkRF
MQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEVMBMGA1UEAwwMTVBHIENBIC0gRzAyAgweKlJIhfynPMVG/KIw
gYsGCyqGSIb3DQEJEAILMXygejBqMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREw
DwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTAT
BgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzFRvyiMA0GCSqGSIb3DQEBAQUABIIBACox
TERYpk2Z42BTrO/OMtKkRIwFIScTaMVnJUiwhOpVwgWzksq6aJNvEa6mk98pX1Tv7wQKjOqH
F5IsWQkkymhDFnd6Lks2YLM10xsDeYbpvbyqANPmiWkAlb5Ls0fBJoRAise4zn3ZwzG+k7cS
FRZBDJKqCwlhI82cr7YnlVvcFSczy9ZHS6hwbRDNIXj6wRGIDntZzU4FWw2djnNBOIjHsjzn
6jjpH2x1r7ODYf8AwzFZa0483ixCcZErIpfgJYMaCR50lXB2VFF+L+adXVp5B1b7wPIkVsb0
vBZW6A8MSyE7mivozE7PQbeZe/glc+WS1C3WK2jCVN8jjWZH+o0AAAAAAAA=
--------------ms090600010600070709030702--
