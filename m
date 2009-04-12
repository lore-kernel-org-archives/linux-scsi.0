From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.27 available
Date: Sat, 11 Apr 2009 22:33:28 -0400
Message-ID: <49E152F8.2020304@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755140AbZDLCdu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Eric Schwartz <emschwar@debian.org>, robbat2@gentoo.org, xiao li - Sun Microsystems - Beijing China <Xiao.L@Sun.COM>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. Ported to FreeBSD,
Tru64, Solaris, and Windows (cygwin and mingw).

This version adds one new utility: sg_write_same. Various
changes made by www.t10.org since June 2008 are reflected
in this version. Thin provisioning support is new and more
support has been added for large sector sizes. The Linux
port adds support for bsg devices. Copy of ChangeLog below.

Note that the web site has changed since the last release.

For an overview of sg3_utils and downloads see this page:
http://sg.danny.cz/sg/sg3_utils.html
The sg_dd utility has its own page at:
http://sg.danny.cz/sg/sg_dd.html
The SG_IO ioctl is discussed at:
http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement has been sent to freshmeat.net .
[Given the current state of freshmeat.net I have no
idea whether that was successful. My sg3_utils and
sg_utils projects were mashed up together.]

Changelog for sg3_utils-1.27 [20090411] [svn: r250]
   - sg_write_same: new utility: 10, 16 and 32 byte cdb variants
   - sg_inq: sync version descriptors with spc4r18
     - add power condition VPD page
     - expand block limits VPD page (sbc3r18)
   - sg_vpd: add power condition VPD page
     - expand block limits VPD page (sbc3r18)
   - sg_map26: fix for lk 2.6.26 when CONFIG_SYSFS_DEPRECATED_V2
     is not defined
     - output cdb when verbose option given
     - correct tape minors >= 32
   - sg_dd: flock flag (does LOCK_EX|LOCK_NB)
     - switch open on input for sg device nodes: first open
       read-write and if that fails try opening read-only
     - experiment with of2=OFILE2; add conv=sparse
     - use posix_fadvise() to defeat caching of normal+block files
       when new 'nocache' flag given
     - sg_dd copied to own package called ddpt
   - sg_dd, sgm_dd, sgp_dd: accept 'count=-1' for calculate count,
     accept '-V' for version string
   - sg_get_config: add OSSC feature [mmc6r02]
   - sg_modes: add ATA power condition mode page
   - sg_logs: protocol specific (SAS) lpage sync to sas2r15
     - power condition transitions lpage (added in spc4r18)
     - extra parameters for start-stop cycle counter lpage
   - sg_format: add '--fmtpinfo=' and '--pie=' options (sbc3r18)
   - sg_readcap: more protection + thin provisioning (sbc3r18)
     - add a '--16' option for 16 byte cdb version
   - sg_persist: code clean up
     - allow '--transport-id=' argument to use space as separator
     - add '--alloc-length=' argument
   - sg_scan: (win32) new format, scsi adapter scan optional
   - sginfo: fix crash when 1024 sg device nodes (or more)
   - sg_ses: allow '--data=' argument to use space as separator
   - sg_senddiag: allow '--raw=' argument to use space as separator
   - sg_reassign: allow '--address=' argument to use space as
     separator
   - sg_wr_mode: allow '--contents=' and '--mask=' arguments to
     use space as separator
   - sg3_utils.spec: correction to configure call
   - sg_pt: add scsi_pt_open_device_flags() call
     - add scsi_pt_version() and clear_scsi_pt_obj() calls
     - clear os_err at start of do_scsi_pt()
     - add linux bsg support via runtime detection
   - sg_cmds: add sg_cmds_open_device_flags()
   - sg_cmds_extra: sg_ll_format_unit: remove rto_req argument,
     the expanded fmtpinfo argument subsumes it.
   - clearer split between Linux and Windows only code and doc
   - automake tools: change to what Ubuntu 8.10 provides
     - Ubuntu 8.10 libtool problems -> Debian 4.0

Changelog for sg3_utils-1.26 [20080625] [svn: r183]
....

Doug Gilbert
