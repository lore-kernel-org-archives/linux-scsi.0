From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Fri, 03 Jan 2014 13:21:18 -0800
Message-ID: <52C729CE.9050307@gmail.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090005070809030508090708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33454 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaACVVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 16:21:23 -0500
In-Reply-To: <20140103195455.GA4193@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090005070809030508090708
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/03/2014 11:54 AM, Sarah Sharp wrote:
> On Fri, Jan 03, 2014 at 07:40:33AM -0800, walt wrote:
>> On 01/02/2014 11:15 AM, Sarah Sharp wrote:
>>> On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
>>>> On 12/18/2013 01:11 PM, Greg Kroah-Hartman wrote:
>>>>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: David Laight <David.Laight@ACULAB.COM>
>>>>>
>>>>> commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e upstream.
>>>>>
>>>>> Section 4.11.7.1 of rev 1.0 of the xhci specification states that a link TRB
>>>>> can only occur at a boundary between underlying USB frames (512 bytes for
>>>>> high speed devices).
>>>>>
>>>>> If this isn't done the USB frames aren't formatted correctly and, for example,
>>>>> the USB3 ethernet ax88179_178a card will stop sending...
>>>>
>>>>
>>>> Unfortunately this patch causes a regression when copying large files to my
>>>> outboard USB3 drive. (Nothing at all to do with networking.)
>>
>>> Do you have CONFIG_USB_DEBUG turned on for 3.13?  If so, you should see
>>> dmesg output from this statement shortly before your drive fails:
>>>
>>> if (num_trbs >= TRBS_PER_SEGMENT) {
>>> 	xhci_err(xhci, "Too many fragments %d, max %d\n",
>>> 		num_trbs, TRBS_PER_SEGMENT - 1);
>>> 	return -ENOMEM;
>>> }
>>
>> Well, the answers depend on whether the usb3 drive uses logical volumes or not
>> (lvm2), which I can't explain.  What I've described so far is with lvm2.
>>
>> When using lvm2 on the usb3 drive, turning on USB_DEBUG has *no* effect

I'm so sorry Sarah, that was another mistake.  The mistake is so stupid I'm not
going to publish it here :(

Once I finally ran the kernel with debugging actually compiled in, dmesg contains
xhci debugging messages.  Wow :)

It's a big file so I zipped and attached it, which I hope is acceptable in lkml.

BTW, this dmesg is from a kernel with sg_tablesize = 31, which as I said before
doesn't fix the problem.  The cp stopped around 7GB just as before.

Sorry for the noise...

--------------090005070809030508090708
Content-Type: application/gzip;
 name="xhci.dmesg.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xhci.dmesg.gz"

H4sICA4kx1IAA3hoY2kuZG1lc2cAxF1rc9u2tv1+fwXunA9NZiwJAN+aunP8SurT2FWttOmd
TCZDkZDEmhJVPhz7/PqzN0hJoExQouyc67aOrXAtbAAb+wWA/Uzgi/ddz3KY9YU8zoPo6zwI
CYWvITWGlPbpkPxzCl+uS+lk4jCPui558xCl+Vvyz+0H4cJ/S+gjfDDxKGWkR0Lx9/98Vvid
Q/k9usOPH1T8VH4Be/74NVpOE7UFTg9uwdxtwXzeQpo9hJ/pl1oL/OAWdsfI244RNdQWWL0F
8+AWgt0WAk0feL0FT9vC1TJcJdEyBwaXkWWSk7kf5yI8IamYFlm0nJE8gZ8zkfdVSkM/LAol
78Do2V9IkU2I12ND4ochPog/sz6oQpAsp9GM/IOdEGAW6dQPBKFvFTyMksT3sjxJ/ZlYY4f4
4ddVmkzE1w20hrMOx8HwzqBDUVgjcDUEv4/PyY2fZWRc/U0oHqIA/8hFACOikHiOpyH5rYjS
+4ws/DyYk2mSkocoJMwxA7KCHyzL94fElHO/pbOpCzqVBVlkk2ETrfIo92Dc5sWEsB4tW8xy
PxfEIaskzTNikWA+kzNMxAPMKeV1NHRegB70VkFU6QHQ8D4fkvciHwNVkUmmoSWJ4TeKi4ET
SsjZxS9k9Ounqzvy66db+J5Fs9NMUHIxvlDaMNBM1SREPmKdbAgZpScgpr+EHoIIoCSMk5vJ
IFuzeJZBDabV2PLjYvK1JPwa+rmP45CsVqiFsrlVEsfwS6WyRh8ZzN2hC8UkKZaBWIs4BFXP
/ZiAgIsMxZ3EYvuLlP2RrWeu4nRKTrPjdJRoC9QoaZgOqk5HmiQ5NNGXjOVHn0FfTksrwmB6
GE4B+TC+PCOj0ZhcXIzVRlC5aiLuzoeBU1Cfj76lTAjQWJZnWaWOEnNI5T/kMkphYfTOgkDA
qsGvD+LRT/EHXEvvYj+bk8s0ehCEMBg3MvptCHp0dju+xj9VMS3btmB2snDLfpbnfjAXYdno
TCxFGgUkmxkkf1qBoFusY9u8jv2chcEX4rigixYnFuO9yRPMSpzMogDmdxInwX02JG9MGCDy
/nxg9B2DvI/O325JXZM6TaSf0giYRmmCRoFEGUmmUxVl2U2omyQUZCyWGeiaacAol/9ugR5r
Bt4m5AKGAfV6gRwrNAtT0NpQwXLa2P+zLCsWiAzlHAQ4nEPyTXYgn6dJMZtvSGyu6e8BAgDW
asR2EsBgNhgnYAmG+I1t/8Y2qXGsaLZpui8WzTY9q5FkraLji/E1+MhF8iBNRhhl92s0A7Nj
Wjsr8BjDA6t0w8ktapla04GcaCGk0yZ5tBBJkZfLXT4JtnVL5djUeLEVYugkDDK6U83Q6Kpm
ijh3qFkFDWYPurwU32BFfutlKwFDiBajcrjLYjERKeGkDD/Wom2ITI/iYjm+98aGynUcr/K9
MAtau7b5Qikvr8e/EE7/lB+Mbs5GervGXdcwyrW5YdfZNXPHrnGIM6olaSlqF34h3LS502bW
GLfJzfmAcUpuFKMGsQPjjYxtRg1Rjt2EUo0af27UAOiYXhNw/8JFrJyYZ9gOC5d7hmM29vcQ
AQzH4y8WwHRsJo1aiEYtZNu/cWCSjhUNMjXjxaI5nDVOziFGDdMjw/lvWA3DYdRzFauR3Uer
FUjHwFpkQRqtIFQm/hQifrKTLyDYoC5XwKGY+kWckxhinQIHFsQwqbd93qVVflE+X4BFIvyE
TIoMjBIxTwgML7R3SgzXUlEeU1C3YNgUcyYnDxKh8A+xDJP0FKyg/BWWW1gE+WlgUlfhYqap
58ryFOYX1vjNND2FQG3NATKOwY748a20nadUJfRUwgpRpjsfUz+4n/hxrDzOTao8fuMvCxjS
vEhFOiQfwNKAiZgrj5uGatO3SVgpcO1BdRrLDLFI/TxKlpAoQvyZZGJJpmmyIPI3FQ0ptas2
U+Wb+PP+fFPiuctKH8wPDNQpV9GY7T7Pm4yGvIkdkTfJNgwsXdQklLEBOzhvMvomBK2GtcOy
E2uwjkkOcpqVZFbnsUM0JjnHpUgeZEhYJ5Ce0ta750+XF/Afo+Tq7HLcY+yGn/PSX7uQMNbd
85abMbd0DhtmnWu2dlwz+lF7BwvGU3whDFJXi1sQyra5Z8w6Pp4PPIPVkg6gNZk+7RWrsurT
I352D0JidYF5nGAjGeiCZZc/kmKZp/4ym4o0FWGNXF+6eg8OYwLGgPx+d062ZSw7hK6A1sWw
NMHo2SdEPK5kNQR+hcY3ynlKeowztTFX3xNYL3EMFKIqPdVgnWW0XJcHGxlpXURDldDgSkuW
oS+n/laIQqCFKYPItZxgtRYLfxnWWFwty0Us/CWyFCsUotZlgnZc5TH1pdF30VKau0zMFkJK
scz9SDLLogfQfrw779fY9H1bsymdApP5mNfg+gpkizCQ7+coCdhg8vGyJo+lV4aLpyAWlU3A
uIDVcIYWh54xFH/jTG2EOVVV15k4ZlWnLvz4bY1WPzwqrRwfkUqxgNAMTAcIL2/O6mT6svlG
j5aqsNhVlcDWT/1Y4IiSS/E3GeUpCRYQOVRc2OnGDq9lBSODxeYtYJWndUDVIaVzW0AgpwVW
UE1SfRl5MADDjKFnspz9bw1jazGfzu5uq3LzRh1PyN/rQcNl7i+fvvlPqi7Zhl4nrmcQnSnr
doUrdhULGWQEGE4n01qPHKrX9HEhPcy0iBunAUf0FCv7cuhUUrcqV+z4hrYkC1EWb0LtSbIA
6LWYjhf7DM/Ua/dr+wwOEc4RPgNgeo14VZ/BaYsyH+wzgOVVfAanziv6DGDTL+79PgPg+kk4
xmcAod5It/gMwOk19nifAbR6S9HuM/xnPoNTVz9zh/gMINCP9nf3Gb4C8Pf4DC4T6m4+AzD6
sT7GZ3Bm6+OPrj6Dc643Al18hq+SGow2Wf/91SDEWl4TtkM1CEi8lpjvpV6Eey0Bl96LWPQY
L2LQljMAei8CsM4yHudFDFnLeKkXMWTN6eVeBHj00nT2IqDGeqn2exGAHyWM1osYrCWhbvEi
gNMLcrwXMViLbrZ6EVgLu17EkMX8F3gRgxn6ZPt7exHZIaVzrV7EYC0xrsaLAEY/PMd4EYMz
/eR19SIGbyl0dPAiFlVJzRY/91IjDuT6sPXVjbhltCRmeiNumfpl+7pG3G4xEIcbcZu/jhG3
W2KS7kbcbjl8c4ARt1sqa0cZcds8zojbLdrwAiNut1Sz2o248dyI29YBetRmxG37/y8VkB1S
OtduxG1bv6Z1Rtx2Xrd8ZDjm65WPDLelot7FiBsqqUfNY1MBwzOtF6UCZh8CHxuPSGZPWS4W
ePgVFi22QpI0FHJ0yrmFIYFnYOnm/dxPZyIfgGamucLjoB14zhOKFcyWWAZPyBEngR/3ppmW
RJ492EfysOhnIsUdx2cELjtAij09ca0djvNU+PfycEp9UCZPQIwKA5/8lUz29s71dob6XzpQ
yQuanidkgq3vNi2fwl+/Rfl8T4eccutLaXe8Rr9L0m9+GpKRn2XfoAlyh3YnyzNs+BN4oWr/
LUmf4Nc8mPcVWgMjpGe0IPTLWB2mEfZSxP4THlWYF3mYfFuScRLcbw4qS7A8Ea6CP0Tws3Q4
MO+HEGhbH4TiYYCjHOQxuQBL4efRJIqj/Inc+gtgHUUroVC55TlfnSyd6ZhtayQ7SycRBHEw
mFePIijKPd53EX5L0oUPwy5/GUssOSvyZAGLIicjNKFqE5a9o/hoyiAe8TeQV2vK5qZulqNs
Jc9TN2rPRbLMEmhBr0CuI4srDWr5cma7iRmFHvn5PFMe9eSJPfXRO1FuNpdL9DmAUd2A/Csp
0qUfP1NWzjzDbtGwFtyuZt7gJCHsbnQhFU+dxn5/i7XBq+sWyJ0IwFKBj/kjiUGZK8XIwCuH
m0GNRFajcwyXN4iCkyUmxawmxhrFwfHuuomNEB8SPyS/iHQpYtxMKeJag9xk1u6YbaAXpfQx
jCF6/hR0A6QOZQgWBZvjiuCNM5lO5XPwrQWkTaDf97LFWkucGe6+GS2dWB3m4S5ok/ruotYY
0zAphjkQCQg8dyYYfuP4zSA/4h8WfrPxm4PfXPzmySep/C4BTCKYQX7aEls202eBL0kxS/KW
qy+vmWLKxhzadbepgnXeEeueYpYtteyAHJRiliwtBzEOTDErnqOyuucpZsnm7d+7ak4xK7g+
8O6aYlaEes3TpJgS51K9IMelmBXtkbtNtqilmCVZy/7ovhSzJGipUnzvFFN2SOmcNsWsJNWn
iw0pZolpOVDQNcWUhB59nRSzJGvZV+2QYtpCIbWZ833qhBX5f8+IQ9DYtU5YwlqqLq9qxG2D
H7D49hlxYHnxkYGSp0XXOxtxYNO7wv1G3DZaynrHGHEg1M9qixG3jQMLet2MONAeVn58ZsQh
X9k14rbRUto/xIgDgV6FvrcRlx1SOtdqxG2jxeRpjLhttEQ5xxhx22w5QtnViNtWS9DcwYg7
TCW1eeOBsX11whLrNNYYO9QJgcThjWeg6xdIttdGzL7LHEepWfT+KvOX8LNjUEhr/vCDomo+
WYoTMk3xYhgt3U3JYfUhh5J3Oh4myWOYPqzLeSZZpQmOI3irIIF56SsAE4d/A5ieZU/L4JTh
+bubaHlKHz3GxcSeuPIT/1H5RCGxsYiwIfk4viiHN8rIDz4SwvAskyL74aRK/eTVs3T70BLL
IfEPqly2qcq1VYT4icSQtULnH0SaoVKZfaNvkzfK5Qa8P+Nj3vt2w8g5rw0v3l6BhJFD4D7c
lgfXlHx968Tu26Ylr5qtoujR/JotJvL6QnXJwZR34+VNvPHN9T9kPDC+OS/WI1zBwQ1/iJbF
I/FnqxnWK7eyPtA+o4b6NJZC9I1JdvJzAmb+Asx+moBLSwle33ucYJSQQt4tu0AVTrlRcBwn
3/LY1MZ3VKQusz0IBGb+JMrJFeT1MKN5uSpSwvvGh196t2ej62qaFLiM/Up4KQCrlnmU/k1M
V47ezfh6AP/1/tzimIWF4Oc4IvI5gO8+foC/csXAZYyJUmw0sIGHD1NTUBwXNxi63tC3hh4d
uuEwnJ6QP68vCQ24fIpc3/0GIiiN2majsFWjfxWLSUKmwsfLPxn5PE39hciGxAO6dTSYPxJY
6sE9mA1cuENyn3xZN+C5VFYop7M4fRziQihiLKYEeJiV/DBKk1UaCVDLpz55c/EWFJJyiDrP
Pl6TjyKYLxO8OIGNYLljORHp7IS8v7q7Obv9vx8IBgN5tq6yKE3KTfrLKPMnsQwWEgjkQqwc
zaRhAceYJ5sV6m+iQsB64CFBL3+0f/osRf5CwBZEi2JBFvAcWYgFlgABXWRCziNywxoFZ0Ym
xRTiYBgcg3suuTnH0ekrzC6WcBRmAssQL4MN8eYNrypJMLS26YP5gsh6uPYfCLcYLi8FHiXy
rhGZ+CleEJr4GVqEqdSCLPo3MCl3eCSDg4mRwlAVxEZnH0lWrOTNIDBSYonl21DFYdav4Naz
WJqnXjm5BG9CWX2LfL4UAQBJeSRXbkSw8spcZb+dPvU4w8OLV39+NHvTjLzJQt96O4RF3VuU
hb4++XWVZ3iXTKRfH/08T9dY0zBdWXBdhl/noS9f9BFvFjplfVatM69pnTl9iIFs9B33DwuM
wDIMCP4o47bo3+VNtNoISITcxVIRI39WBrbKk27foqA9MMaTKBmSquyZxf6E/Aif9NhPuGir
KfX61DDclj325sSlhJnd7scwNuVGMKWaxMVivClzkU15LVn/QZlLxaLPEQ7MXEqellfYdMpc
KrZjM5cSbh4lTGPmUhG2jNJO5kJVnHXYebLDM5eK9rAz1M/LT14tcynJWm6N7MtcSoKWc+7f
vfzkKeUnrylzqU1Hy2mFhsylxHj6RKNr5oKEJjX1yUaXzEWSMfYqF2Rg6NakuA+KCV6RTeb4
SqS9732qIO5BkJ1XPnn4rgzTsHawrL05gFSXoPdBnjdnmOsb0Yitbii3NwcQ8zBIQ3NgOcrr
3Zj1oBud4Y4f7lKhkm6RVexaNqLALbZpurwT/jOEjMhVITaPmp6MBTZ+O1z06FsM68rduSnu
7JWbvNLvy9MJGB35uS+ToLVbf7OEBGdjHwzLZC2WXecJJazrcUTbp76nK+FpPSE0xVu2fA70
hMjScnz0YE8oeY7a+2jyhJJt/8lBnSeUcP0sdPeESNjyjkBNDa/CvcwT8gZPKGkP29955gm9
yY4nlGTHn/WrCFqscUdPyLeOzT3EE8oOKZ3T1vBKSVsWdaMnlJjXO7BdEnp6wm6eEMiMlrt/
HTyhN1FIPRPfuRktVwUkcx/EMnlIyHmMhmscxffSHP8iniYJHp3yM3lCCPLEbLAKoirrGWzK
HEafDsCOWwPwV4PKRQ4kdfnd3DRrM4arFix+b/2OAyAxhsy5eje0Kb/E18ZhKlXKtXYKD+AE
2Vaez+3yfsEDJ/guQ1VAkEyS0q0spoX3br7bEDB1CKxtsxbHnZD2IeCaIbgsz328ZACYIom8
rL8egOoFK/W3s+ztOC87bg4geBhUAYTacVtpzsGT9c86Tk37cnhhUrcvf23qOMWTOBn2u1HI
5/0FqUAcZcIZ7VuOxzwY+bPqDS7MNB2D35Psm7/aHILLQt/uEzJKI1ii+dOwx8BT52C1syEj
fpAmWTbcIN+N19y2QeVVOLW04LwwRGFmnzue0XJouDFEqWCW3pc1J+sT6EFodgpRsCmX8pY9
50NClDVLywbaQSHKmueoqOBZiFKxtVwLbw1R1vBXS9bXhPqYoDlEWeNedh3hWYiyptUPdnuI
EqghSkXWEn7tCVHWBK93HaFziBIoIUqgD1HWkna5mVxhWqp2HUOUktBouS/ZIUSpyFouWHQJ
UQKV1GlZy1rbB7AWZW9Oz1zhuJNu6VnVVMtplsNtn9Oy69zF9rWd2utu+5yWtxkcYPsc59XS
s4qw5c0FbbbPcV85PVvTHpme+fS57XMOuZfdZvuclvcWfG/b5yv3af2W+7SVpC2Xx3W2z3m9
QmVJ6FqvUqgsybyWE1IdbJ9f3adlVt/ywNFz7WmFOxEIsGOhPBYuYL3kCZnGRTYnKR6dXwhS
Acp3Go4giq6onT7zTBsjVe3eaxwt7wleSFEROP6dEA5efr8ePdhDcnZ5eXfx6+27N7dXHy+v
/vj6+wgCYwUZZfLd/6nww6eSwe07mCiyfW0WK/V5rHA0t3jx89nt+6t6qxMBsyoypVnu9R1w
Y46pHfd3fhSX16AQRc4uPsi84cFPB3EyG1RPD4Tl8ClzzKnluU7IzNCDyQzL/7GD75jWALcX
ewwS3X4FOSFRpXRDyANE9WpKHJVqh7Ta7POcvo3vdQV9U98GSdl6m9+iDduPEuW6dn0f+F2U
ilm82Y+eyy6BqgwJXqZSgJ7rHQ7kW6DHdjZ+W4GGAuRGHYinB6BnV8q2Jz5omfJ/BaE8eCfw
Kh5e+jov33kIC3DuY6KVTKf/ae5cdts2ojC8z1MwuwSw07lfFHRR2wXcdFGgaFZFIdCSDKlR
ZcOMG/vtOzMkpTmSrdBsGP7ZBBY4hz/n8s0ZcuacMJgn7UdqztK/gtjyX7P1cVMRa9ez0Kzb
D99yz6CL/tVLDaZO0hqc72tM4b1eZpIHUqudzVlrkbswakKf1Ec2n5ebWWgo4inZuViw6CnF
8LT8pN6yW/tH9R6f8nNz512+F5bf70iopwP6h+X6uwCSY1FVHi7PfymWcW9NzZDq9qZ2LcIg
jX7Ngdv1jhh+/uG3+9GS8cCo+WP46yTNNO3PxNaRDaDhwS5DsXRI5/I8L3Qk/t6vq5RGIlZ/
fcSnWocnjChPtR48qMVD/QVwa+x5BZ2MidzYEe+tkzGZGzsS5+W8rI3FT07L2XS+WszfvM3K
8iNvFy7Pi3j9+2K2c5LzokfWAbt+M9vtyYqtHJiUNyvXTeYOR0PIsiaErDgIQJs3CbdNAgzf
q3QbQDolukmhmFdVkLsJK5OT/Yj1pJzPyt1v2g9zaWxtYyO3F3vx7MW7T3hZNpimnEhnU7Md
mM2ryTD4Q3umDTrbWb0Jkr24uwud5S5MvP8u7h53tlQaO4e7OT9ulmHApgVPKhl9r7yU5k+V
KsglMkHyfv15klo77h37kT0w3nxibP9mpNCTB9nPL84m1HYQPZtf/cn+ChZEOSlEWcQAiTJu
tmO6aOMlFtdt1MS2pAm9InBp2rhvweX84bf6GWuuhvsFoqYzioXW4Tm1IOVj1bdvGr+Ud6nn
v2lTBtXfRsNaTE3jPeKmIMlNdo+0qbZB5CqeICyElFKkeJwtutNkUTgZvAbmdnBPc0zhvTBW
vCWKwhOdpY1o2X2CC5OJOqHRiBsrxIjrZ0TmRuIisY8RRYyIfkY0MSL7GTHEiO5nxBIjtp8R
R4z0bB2fG/H9WseR7u/7tY7jmRHOX14nOpS1gmhJe1TWcRpJe93r7erNTk9qNtjLy8VvlB/O
LsSk+Dldcqq3yb6KL8vFJsxk87KJ5VAv5cJKIPAqCYlzbjR46nZTlRBMjY4FyzIsiDra6MiK
JFUUX9qMrMhQRd6PrsgTRZzrsRU5QRWJ0evIaapIydEVOapIjz7WwoKfKLKj15FXVJEfnZDe
EkVpe9eoimKmEKJIjD36JaPMFqPPa5JRZovRx5pklNli9LEW44sSRX58RZTZko09i0hOmS3H
H2uCMlvGzccjK6LMTieZR1ZEmS3N0D7kVspXdDlGdLmh266jLsmpLg9SX6Fz57oUG5riXXVZ
qkuA1JdiVJcEqS8lqS6NUl+G6rIg41F5qssNPet01KUF0aUZSH1pTXXxoT2Zrroo77UAGY+G
8l4P7q931UV5rwf3JLrqorzXg7/O76jLUt5rN/TatKsuynsTU45D6KK8T2HZIXRR3hsJwlVH
eW8UyLztKO/N4Kv7rroo783ga/yOujzlvUHhhKe8tyic8JT3lmP0r7griOiSGPOQYpT3FoQT
ilHeWz30+6SuuijvLQgnFKe8T1uUIXRR3juGMW8rTnnvBEg7Csp7B/IeQAnK+xToCEIX5b0z
GPOjkpT3zoHwXlLeO4/xfkJJyns/+PeDrroo770A4ZeivPeDfyPvqovy3oP490pR3nuL4a8q
TXnvQfx7pQnv44drEF12TxcIJwwD1SVBdRlQXR5TlxWgujSoLoepy3FQXfu8R9EFynsPynsP
ynsPynuPyXvNMHmvGSbvNcPkveaYvNcck/eaY/JeC0zea4HJey0wea8FKO/l9+Z9TLlrBTe1
MGOkN/GPJ4Q5UGEaVZgDFaY4qjCFKsyCCgv+DqgwiSrMoArzoMIMKvkNKvkNKvktKvktKvkt
KvkdKvkdKvkdKvkdKvk9Kvk9Kvk9KPkNAyW/YaDkNwyU/IaDkt9wUPKHH1GFgZLfCFDyGwFK
/rBIAhUmUckvUckvUcmvUMmvUMmvUMmvUMmvUcmvUcmvUclvUMlvUMlvUMlvUclvUclvUclv
UcnvUMnvUMnvCPmVjocvfrq6qa9qY4jS+KYkfKhK4RH+b0TUaMb2iIgaysVQ6N82IqoiJ0fb
rLEXi3X5GGzWBct1+K9Ot3BdZ3eIpvbaovy8fe6mVQxXqs7k9k/5UJuqCsGUq3+sH1IyosUe
avljuaqKanlzv56naNnL8vZ2sXn9uriIeeG+rNahohepNl/lpnR2cKu+FelyQX7d6VLlx2ao
JjEV8aT40NTcsqyK8mqbV6K265l9eXReRsrLPk3vmRv6ABMdRM/ueDGeeCmes6FPHncWpqgw
MfTRvc7CLBUmhz4r1FGYZYwKGzxIVGdhkgobPEpUZ2GGCkMZlZYRL8WL7zznPi+MCyps8IOY
nYVpKmzwCAqdhTkqzAx9hK+rMEHJLyxKHxOU/CmvNIYwSn7JUfqYpOSXg4c16SyMkl+qoc8h
dxaWk18yLuWhq3p7F4Td3FeZgHDjzAVvnfXckH55CgxGyuseDmUsZ486yE29NuuI6Wy5mH2a
pmqZaBNXCM2yo3GR2wVHfgfDD6vo90VK9xyrNsv3HDPgnN5s1o+k+LeqYfPyRRupKdNntRbL
+cMH2F9zFH9fzUVTrwVnQqWbVCexu2476/t4j+I0WytJoaPfvctJVF1N56sq5n6bNo+1uf8U
aznmJ49JqF79B3BBU4eq0gAA
--------------090005070809030508090708--
