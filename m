From: Matthew Wilcox <matthew@wil.cx>
Subject: grsec problem in scsi_ioctl
Date: Fri, 7 Jan 2005 19:49:03 +0000
Message-ID: <20050107194903.GB27371@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61881 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261574AbVAGTtJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 14:49:09 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1Cn06a-00085u-O4
	for linux-scsi@vger.kernel.org; Fri, 07 Jan 2005 19:49:04 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


What a pleasant way to find out about a vulnerability ...

much snipped, I'm sure you can find the whole thing if you care to.

----- Forwarded message from Andres Salomon <dilinger@voxel.net> -----

Date: Fri, 7 Jan 2005 12:20:49 -0500
To: grsecurity@grsecurity.net, dailydave@lists.immunitysec.com, bugtraq@securityfocus.com, full-disclosure@lists.netsys.com
From: spender@grsecurity.net (Brad Spengler)
Subject: [Full-Disclosure] [grsec] grsecurity 2.1.0 release / 5 Linux
	kernel advisories

2) Linux Kernel advisory introduction

Let me begin by giving you a timeline:

December 15th: I send Linus a mail with a subject line of
"RLIMIT_MEMLOCK bypass with locked stack"
December 27th: The PaX team sends Linus a mail with a subject line of
"2.6.9+ mlockall/expand_down DoS by unprivileged users"
January 2nd: The PaX team resends the previous mail to Linux and Andrew
Morton

Between December 15th and today, Linus has committed many changes to
the kernel.  Between January 2nd and today, Andrew Morton has committed
several changes to the kernel.  3 weeks is a sufficient amount of time
to be able to expect even a reply about a given vulnerability.  A patch
for the vulnerability was attached to the mails, and in the PaX team's
mails, a working exploit as well.  Private notification of
vulnerabilities is a privilege, and when that privilege is abused by not
responding promptly, it deserves to be revoked.

Using 'advanced static analysis': "cd drivers; grep copy_from_user -r ./* |
grep -v sizeof", I discovered 4 exploitable vulnerabilities in a matter
of 15 minutes.  More vulnerabilities were found in 2.6 than in 2.4.
It's a pretty sad state of affairs for Linux security when someone can
find 4 exploitable vulnerabilities in a matter of minutes.  Since there
was no point in sending more vulnerability reports when the first hadn't
even been responded to, I'm including all four of them in this mail, as
well as a POC for the poolsize bug.  The other bugs can have POCs 
written
for just as trivially.  The poolsize bug requires uid 0, but not any
root capabilities.  The scsi and serial bugs depend on the permissions
of their respective devices, and thus can possibly be exploited as
non-root.  The scsi bug in particular has a couple different attack
vectors that I haven't even bothered to investigate.  Some of these bugs
have gone unfixed for several years.

The PaX team discovered the mlockall DoS. It has been fixed in PaX for
2 years.  I have attached their mail and exploit code.

I'd really like to know what's being done about this pitiful trend of
Linux security, where it's 10x as easy to find a vulnerability in the
kernel than it is in any app on the system, where isec releases at
least one critical vulnerability for each kernel version.  I don't see
that the 2.6 development model is doing anything to help this (as the
spectrum of these vulnerabilities demonstrate), by throwing
experimental code into the kernel and claiming it to be "stable".
Hopefully now these vulnerabilities will be fixed in a timely manner.

4) 2.6 scsi ioctl integer overflow and information leak

In drivers/block/scsi_ioctl.c:

at sg_scsi_ioctl():
>        struct request *rq;
>        int err, in_len, out_len, bytes, opcode, cmdlen;
        ^ in_len, out_len are signed int
>        char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
>
>        /*
>         * get in an out lengths, verify they don't exceed a page worth of data
>         */
>        if (get_user(in_len, &sic->inlen))
        ^ in_len is user-controlled
>                return -EFAULT;
>        if (get_user(out_len, &sic->outlen))
        ^ out_len is user-controlled
>                return -EFAULT;
>        if (in_len > PAGE_SIZE || out_len > PAGE_SIZE)
        ^ signed int only has upper bound checked
>                return -EINVAL;
>        if (get_user(opcode, sic->data))
>                return -EFAULT;
>        bytes = max(in_len, out_len);
...
>        rq->cmd_len = cmdlen;
>        if (copy_from_user(rq->cmd, sic->data, cmdlen))
>                goto error;
>         
>        if (copy_from_user(buffer, sic->data + cmdlen, in_len))
                ^ copy_from_user with size possibly > PAGE_SIZE
>                goto error;
...
>                if (copy_to_user(sic->data, buffer, out_len))
                ^ copy_to_user with size possibly > PAGE_SIZE
>                        err = -EFAULT;

----- End forwarded message -----

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
