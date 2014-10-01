From: Jerome Martin <jxm@netiant.com>
Subject: Re: targetcli do not show iscsi
Date: Wed, 01 Oct 2014 13:49:40 +0200
Message-ID: <542BEA54.50903@netiant.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com> <542ACDAE.3080307@gmail.com> <542AD1C2.8070105@gmail.com> <542ADF1D.1020003@gmail.com> <542ADFDB.3010300@netiant.com> <542AE206.4000808@gmail.com> <542AE3E2.1080609@netiant.com> <542BE74F.3080102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542BE74F.3080102@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Luigi Tarenga <luigi.tarenga@gmail.com>, linux-scsi@vger.kernel.org, "target-devel@vger.kernel.org >> target-devel" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Luigi,

On 10/01/2014 01:36 PM, Luigi Tarenga wrote:
> Hi Jerome,
> I did some test with 3.x version but I have some problem.
> Let's start saying i cloned your git repos.
>
> I have a problem generating the rpm with all 3 package (configshell,
> rtslib, targetcli):
> # make rpm
> Exporting the repository files...
> Cleaning up the target tree...
> Fixing version string...
> Generating rpm specfile from template...
> Generating rpm changelog...
> Generating debian changelog...
> Generated release tarball:
>      dist/configshell-1.5-4-g0827baa.tar.gz
> Building rpm packages...
> error: line 7: Illegal char '-' in: Version:        1.5-4-g0827baa
> make: *** [build/rpm-stamp] Error 1
>
> the error is the same, seem you can't use a hyphen in the version.

Ah, right.
I need to update that, there were some changes in the versionning that 
breaks the included RPM packaging. Typically the packaging from the git 
repo is only used for development as distros tend to bin it and replace 
with their own. I will fix that ASAP.

> For now I gave up building rpm and did a simple ./setup.py install:

Great :-)
However, you should generate a release first (make release) and then do 
the install from the generated tarball, as this will extract version 
information etc. from the git repo. Also, you will need to install the 
initscript manually.

> still having an issue about the listing of iscsi fabric:
> # /usr/bin/targetcli ls
> o- /
> .........................................................................................................................
> [...]
>    o- backstores
> ..............................................................................................................
> [...]
>      o- fileio
> ...................................................................................................
> [0 Storage Object]
>      o- iblock
> ...................................................................................................
> [0 Storage Object]
>      o- pscsi
> ....................................................................................................
> [0 Storage Object]
>      o- rd_mcp
> ...................................................................................................
> [0 Storage Object]
>
> # /usr/bin/targetcli version
> Cannot find configshell version. The configshell package has probably
> not been built properly from either the git repository or a public tarball.
> Cannot find rtslib version. The rtslib package has probably not been
> built properly from either the git repository or a public tarball.
> Cannot find targetcli version. The targetcli package has probably not
> been built properly from either the git repository or a public tarball.

This is what I was talking about above, you need to generate a release 
tarball first (make release).

>
> I tried with both python (stock from centos) and python2.7 (compiled
> from source in /usr/local)

So, again, I would like to reproduce and solve this on CentOS / RHEL.
Can you confirm this is version 6.5 with custom-built kernel 3.16.3 ?

In any case, thanks for testing, I need that badly :-)

Best Regards,
--
Jerome
