From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 3/6] sd: don't bother spinning up disks on resume
Date: Mon, 11 Nov 2013 09:28:51 -0500
Message-ID: <5280E9A3.1070407@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <ece4db4b486db3594ad3b97aa00f7eb5fef93c4b.1384030893.git.psusi@ubuntu.com> <5280D6E4.6010804@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:39349 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3KKO2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2013 09:28:52 -0500
In-Reply-To: <5280D6E4.6010804@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/11/2013 8:08 AM, Sergei Shtylyov wrote:
>> -    unsigned manage_start_stop:1;    /* Let HLD (sd) manage 
>> start/stop */ +    unsigned manage_start_stop:2;    /* Let HLD
>> (sd) manage start/stop */
> 
> I think you should better document this 2-bit field, or better
> still, make it 2 1-bit fields.

Not a bad idea, though I'm really not sure that it shouldn't just be
removed entirely.  It is a bad idea to not stop the disk on
suspend/shutdown since it leaves the disk to take an emergency head
retract, which isn't good for it.  At the very least it should park
the heads, though currently libata does not handle the scsi cmd for that.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSgOmiAAoJEJrBOlT6nu755CcH/2ckSBdvCtMHFe1ech1XFOdJ
PUZc5VEHk/rzPqXqxS26H9eR5FIbgu437yVizJ/w5Fy4MAX0rVKyz61FK/HavGL7
aqNYgKWIjucg7panlWZsPIraDl/bVPYVS2PnthVItabC+GskYRR0g92xcDqDPSeX
kmFIG0JOx2bU6JYWtFWxECpdjsBJBQxAnoLtzI+SONmlhp2GxH9Bc9Msa5hqwBoW
vmUJmggBaPoL3ZTQUFGZyYWU8/7n2d5lhXpJdcsvcrd+PJyrsfv9GGKqgQW/kLmL
sYAFwO83/5YJUK03l68S9xHt48NW2rdFm2ph035/CpbsNib2fKTaOsyfIgf/Idg=
=y73A
-----END PGP SIGNATURE-----
