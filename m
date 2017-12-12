From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 09:35:12 -0800
Message-ID: <1513100112.3110.28.camel@HansenPartnership.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
         <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
         <yq1indbq2sb.fsf@oracle.com>
         <CA+55aFyzrHj+rMN7Ct7xCEWZT=viXYAC1WZjfgFnM_R0tq1n5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyzrHj+rMN7Ct7xCEWZT=viXYAC1WZjfgFnM_R0tq1n5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-12-12 at 09:32 -0800, Linus Torvalds wrote:
> On Tue, Dec 12, 2017 at 9:22 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> > 
> > 
> > Arnd and Johannes fixed this up right away:
> 
> The commit you point to _is_ the probnlem. It does:
> 
>     struct bfad_im_port_s *im_port = shost->hostdata[0];
> 
> which is utter bullshit crap.
> 
> Notice? It's assigning a pointer (im_port), from an integer value
> ("hostdata[0]" is "unsigned long").
> 
> The code is garbage.

he means this one:

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?h=fixes&id=48d83282db077f93b2cf40de120f4d6f29eb293b

Which properly encapsulates the reference in a function which does the correct conversions.

James
