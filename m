From: Matthew Jacob <mjacob@feral.com>
Subject: Re: sense buffer length for REQUEST SENSE?
Date: Fri, 26 Jul 2002 20:57:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0207262054090.60229-100000@beppo>
References: <3D4225D5.9A8ED692@torque.net>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D4225D5.9A8ED692@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>


> Yes I can see that number in SPC-3. Has anyone every seen
> an actual REQUEST SENSE response (sense buffer) anywhere near 
> that size? The new "descriptor" sense data format should
> further reduce the size requirement.

Some specialized RAID units do this, IIRC. Very rare.

Every now and then I get a Fibre Channel disk that actually sends back via the
QLogic HBA several continuation responses- that means the sense data is > 64
bytes.

I wouldn't expect this to be anything but rare. Even if you have such data,
it's probably very application specific that you'd *do* anything with it. I
would think 64 is fine. Perhaps one should architect an exception condition
that is similar to AUTOSENSE FAILED, i.e. AUTOSENSE OVERFLOW- it's up to the
HBA to store the 252 bytes of data somewhere until a REQUEST SENSE comes down
to pick it up. And the REQUEST SENSE can have more than enough data space
allocated.

