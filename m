From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Delete trailing full stop
Date: Sat, 19 Nov 2005 10:48:57 +1000
Message-ID: <437E7679.2040700@torque.net>
References: <20051117181343.GD17171@parisc-linux.org> <437D77C2.3000908@torque.net> <20051118132048.GI17171@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100070906070806010601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:177 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751242AbVKSArw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 19:47:52 -0500
In-Reply-To: <20051118132048.GI17171@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090100070906070806010601
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> On Fri, Nov 18, 2005 at 04:42:10PM +1000, Douglas Gilbert wrote:
> 
>>Matthew Wilcox wrote:
>>
>>>None of the other domain validation messages have a trailing full stop,
>>>so I don't see why this one should.
>>
>>Speaking of domain validation messages I have noticed
>>that either the sym53c8xx driver or scsi_transport_spi is
>>getting noisier in this area.
> 
> 
> Definitely the sym2 driver's fault.
> 
> 
>> target0:0:3: Beginning Domain Validation
>> target0:0:3: asynchronous.
>> target0:0:3: wide asynchronous.
>> target0:0:3: Domain Validation skipping write tests
>> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>> target0:0:3: Ending Domain Validation
>> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>> last message repeated 2 times
>>sdb: Spinning up disk....<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>> last message repeated 7 times
> 
> (etc)
> 
>>Surely one "FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)"
>>message is sufficient?
> 
> 
> Absolutely.  Let's see why it's happening.  That message is displayed by
> spi_display_xfer_agreement() which is called from three places in sym2.
> However, because DT is set, it must be called from sym_setpprot() [1].
> That's only called in a way which would cause this message from
> sym_ppr_nego_check(), which is only called from sym_ppr_nego(), which is 
> only called when receiving a PPR message.
> 
> Now, what I don't know is why the device keeps sending us a PPR message.
> Do we keep sending it a PPR message?  Can you turn on negotiation
> debugging (echo setdebug nego >/proc/scsi/sym53c8xx/0) and send me the
> results?
> 
> [1] SDTR and WDTR clear DT.  So it must be in response to a PPR message.

I switched disks from a Fujitsu MAM3184 to a Seagate
ST318451 and it seems just as noisy. See attached.

If the disk is spinning when a scan is requested then
the output is succinct; so all that extra output
occurs while the disk is in the process of spinning
up (about a ten second period).

Doug Gilbert


--------------090100070906070806010601
Content-Type: application/x-gzip;
 name="sym53c8xx_scan2.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sym53c8xx_scan2.txt.gz"

H4sICPF1fkMAA3N5bTUzYzh4eF9zY2FuMi50eHQA7dtPb9owGAbwO5/iPa7SzOwEGIvGpHSw
qdK6w0DtOdgGLFonsg2Ibz8nsK2Dtuppq6InSJZInrz5OX/em4lutFWly2g6yb/mswkRXZdK
38Uds1QMe33x7ZaO2w+9zYhznnaIZvtKZ3Hf2DgtA8ul1N7To1v+fXpF089xcHprvCltrBJr
hMItdRAZjz+61EtjrbFLGpf3hbF0U9wZVYSYPkn6vZV075flJmQkWMoEKxjvPpEy9u/Q4XAd
UCHOulz4EadKu5HgpMw2/lkU6zjK1XJ0VrSoq65cacuNPz22M0o/YCX1NZ/KHFC/Ir9Ju4ZU
h0biccB/nHtjf+4GnD038mtTVfUj3TkTNAXtgz85qarcg/kMWI99YJylOpqT0wscs4dZPR/9
kk9nbMjp9mo8Obx6YsC7nK4v33kaz+iNSLp9sv5tvAkLrwMNkouTEhOrXvI2vt4JQPYSmVfz
2OqqY+/ZVPFD8Otu3D4OPr1eNWSQQQZZW2TotpBBBhlk6LaQQQYZZG2RodtCBhlkkKHbQgYZ
ZJC1RYZuCxlkkEGGbgsZZJBB1hYZui1kkEEGGbotZJBBBllbZOi2kEEGGWTotpBBBhlkbZF1
nS7UvtPEld4aqalZ5Jv2h7108F5QXyRsvg+aVmrnyGsZSudjrWHaT2Lpi/NTlTNbTbKQK50d
F7PPC7n+J9c4HI2DqIek49Wfdfx5CHVekZfeNCuX60znJ0VMDirVQQAA
--------------090100070906070806010601--
